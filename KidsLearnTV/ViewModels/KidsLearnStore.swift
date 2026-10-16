import SwiftUI

@MainActor
final class KidsLearnStore: ObservableObject {
    enum Screen: Equatable { case welcome, menu, learning, quiz, feedback, results, rewards }
    @Published var screen: Screen = .welcome
    @Published var category: LearningCategory = .abc
    @Published var lessonIndex = 0
    @Published var round: QuizRound?
    @Published var progress: LearningProgress = ProgressPersistence.read()
    @Published var lastMode: QuizMode = .mixed
    @Published var errorMessage: String?

    var currentLesson: Lesson {
        let list = LearningContent.lessons(for: category)
        return list[min(lessonIndex, list.count - 1)]
    }
    var lessonCount: Int { LearningContent.lessons(for: category).count }
    func goMenu() { screen = .menu; round = nil }
    func startLesson(_ category: LearningCategory) { self.category = category; lessonIndex = 0; screen = .learning }
    func moveLesson(backward: Bool) {
        if backward { lessonIndex = max(0, lessonIndex - 1); return }
        progress.completedLessonIDs.insert(currentLesson.id)
        save()
        if lessonIndex + 1 < lessonCount { lessonIndex += 1 }
        else { screen = .menu }
    }
    func startQuiz(mode: QuizMode) {
        lastMode = mode
        let category: LearningCategory?
        switch mode { case .category(let selected): category = selected; case .mixed, .twoPlayer: category = nil }
        let pool = LearningContent.questions(for: category)
        let selected = Array(pool.shuffled().prefix(5))
        guard selected.count == 5 else {
            errorMessage = "Not enough quiz questions are available."; return
        }
        round = QuizRound(mode: mode, questions: selected)
        screen = .quiz
    }
    func answer(_ option: String) {
        guard round?.submit(option) == true else { return }
        screen = .feedback
    }
    func nextQuestion() {
        guard round != nil else { return }
        round?.advance()
        if round?.completed == true {
            progress.totalStars += round?.totalCorrect ?? 0
            progress.quizzesPlayed += 1
            if round?.isTwoPlayer == true { progress.twoPlayerRounds += 1 }
            save()
            screen = .results
        } else { screen = .quiz }
    }
    func showRewards() { screen = .rewards }
    func abandonQuiz() { round = nil; screen = .menu }
    func replay() { startQuiz(mode: lastMode) }
    private func save() { ProgressPersistence.write(progress) }
}
