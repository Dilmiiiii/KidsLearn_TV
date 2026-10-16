import Foundation

enum QuizMode: Codable, Equatable {
    case category(LearningCategory)
    case mixed
    case twoPlayer
}

struct QuizRound: Codable {
    let mode: QuizMode
    let questions: [QuizQuestion]
    private(set) var playerIndex: Int = 0
    private(set) var questionIndex: Int = 0
    private(set) var scores: [Int] = [0, 0]
    private(set) var answerLocked = false
    private(set) var selectedAnswer: String?
    private(set) var completed = false
    var activeQuestion: QuizQuestion { questions[questionIndex] }
    var wasCorrect: Bool { selectedAnswer == activeQuestion.answer }
    var isTwoPlayer: Bool { mode == .twoPlayer }
    var isLastQuestion: Bool { questionIndex == questions.count - 1 }
    var isFinalTurn: Bool { isLastQuestion && (!isTwoPlayer || playerIndex == 1) }
    var totalCorrect: Int { scores.reduce(0, +) }
    var currentScore: Int { scores[playerIndex] }

    init(mode: QuizMode, questions: [QuizQuestion]) {
        precondition(!questions.isEmpty, "Quiz requires at least one question")
        self.mode = mode; self.questions = questions
    }

    /// Returns false on invalid/duplicate answers. A submitted answer is scored once.
    @discardableResult
    mutating func submit(_ answer: String) -> Bool {
        guard !answerLocked, !completed, activeQuestion.options.contains(answer) else { return false }
        selectedAnswer = answer
        answerLocked = true
        if wasCorrect { scores[playerIndex] += 1 }
        return true
    }

    /// Advances the same question set to player 2 for a fair shared-remote challenge.
    mutating func advance() {
        guard answerLocked, !completed else { return }
        answerLocked = false; selectedAnswer = nil
        if questionIndex + 1 < questions.count { questionIndex += 1 }
        else if isTwoPlayer && playerIndex == 0 { playerIndex = 1; questionIndex = 0 }
        else { completed = true }
    }

    static func rating(for score: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        let ratio = Double(score) / Double(total)
        if ratio >= 1 { return 3 }
        if ratio >= 0.6 { return 2 }
        return 1
    }
    static func message(for score: Int, total: Int) -> String {
        switch rating(for: score, total: total) {
        case 3: return "Perfect! You're a Learning Superstar!"
        case 2: return "Fantastic Effort! Keep Exploring!"
        default: return "Great Try! Every Step Helps You Learn!"
        }
    }
}

struct LearningProgress: Codable, Equatable {
    var completedLessonIDs: Set<String> = []
    var totalStars: Int = 0
    var quizzesPlayed: Int = 0
    var twoPlayerRounds: Int = 0
    func badgeUnlocked(_ name: String) -> Bool {
        switch name {
        case "ABC Explorer": return allLessons(.abc)
        case "Number Hero": return allLessons(.numbers)
        case "Colour Artist": return allLessons(.colours)
        case "Animal Friend": return allLessons(.animals)
        case "Quiz Star": return quizzesPlayed > 0
        default: return false
        }
    }
    private func allLessons(_ category: LearningCategory) -> Bool {
        let categoryIDs = LearningContent.lessons(for: category).map(\.id)
        return !categoryIDs.isEmpty && categoryIDs.allSatisfy { completedLessonIDs.contains($0) }
    }
}

enum ProgressPersistence {
    private static let key = "kidslearn.progress.v1"
    static func read(defaults: UserDefaults = .standard) -> LearningProgress {
        guard let bytes = defaults.data(forKey: key), let value = try? JSONDecoder().decode(LearningProgress.self, from: bytes) else {
            return LearningProgress()
        }
        return value
    }
    static func write(_ progress: LearningProgress, defaults: UserDefaults = .standard) {
        guard let bytes = try? JSONEncoder().encode(progress) else { return }
        defaults.set(bytes, forKey: key)
    }
    static func reset(defaults: UserDefaults = .standard) { defaults.removeObject(forKey: key) }
}
