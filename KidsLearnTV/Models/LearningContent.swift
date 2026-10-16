import Foundation

enum LearningCategory: String, Codable, CaseIterable, Identifiable {
    case abc, numbers, colours, animals
    var id: String { rawValue }
    var title: String {
        switch self {
        case .abc: return "ABC World"
        case .numbers: return "Number Land"
        case .colours: return "Colour Splash"
        case .animals: return "Animal Kingdom"
        }
    }
    var description: String {
        switch self {
        case .abc: return "Discover letters and the words they begin with."
        case .numbers: return "Count, recognise and play with numbers."
        case .colours: return "Find, name and match colourful objects."
        case .animals: return "Meet animals and discover their sounds."
        }
    }
    var cta: String {
        switch self {
        case .abc: return "Explore Letters"
        case .numbers: return "Start Counting"
        case .colours: return "Explore Colours"
        case .animals: return "Meet Animals"
        }
    }
    var emblem: String {
        switch self { case .abc: return "🔤"; case .numbers: return "🔢"; case .colours: return "🎨"; case .animals: return "🦁" }
    }
}

struct Lesson: Identifiable, Codable, Hashable {
    let id: String
    let category: LearningCategory
    let title: String
    let visual: String
    let narration: String
    let soundDescription: String?
    init(_ category: LearningCategory, _ title: String, _ visual: String, _ narration: String, sound: String? = nil) {
        self.id = "\(category.rawValue)|\(title.lowercased())"
        self.category = category; self.title = title; self.visual = visual
        self.narration = narration; self.soundDescription = sound
    }
}

struct QuizQuestion: Identifiable, Codable, Hashable {
    let id: String
    let category: LearningCategory
    let question: String
    let options: [String]
    let answer: String
    let cue: String
    let official: Bool
    init(_ id: String, _ category: LearningCategory, _ question: String,
         _ options: [String], _ answer: String, cue: String = "", official: Bool = false) {
        self.id = id; self.category = category; self.question = question
        self.options = options; self.answer = answer; self.cue = cue; self.official = official
    }
}

enum LearningContent {
    static let lessons: [Lesson] = [
        Lesson(.abc, "A — Apple", "🍎", "A is for Apple. Say it with me: A!"),
        Lesson(.abc, "B — Ball", "⚽️", "B is for Ball. Say it with me: B!"),
        Lesson(.abc, "C — Cat", "🐈", "C is for Cat. Say it with me: C!"),
        Lesson(.abc, "D — Dog", "🐕", "D is for Dog. Say it with me: D!"),
        Lesson(.abc, "E — Elephant", "🐘", "E is for Elephant. Say it with me: E!"),
        Lesson(.numbers, "1 — One star", "⭐️", "This is one. Count one star!"),
        Lesson(.numbers, "2 — Two ducks", "🦆 🦆", "One, two. Two ducks!"),
        Lesson(.numbers, "3 — Three apples", "🍎 🍎 🍎", "One, two, three. Three apples!"),
        Lesson(.numbers, "4 — Four balloons", "🎈 🎈 🎈 🎈", "Let's count four balloons!"),
        Lesson(.numbers, "5 — Five flowers", "🌼 🌼 🌼 🌼 🌼", "Great counting! Five flowers!"),
        Lesson(.colours, "Red — Apple", "🍎", "This apple is red. Can you say red?"),
        Lesson(.colours, "Blue — Sky", "🌤️", "The sky is blue."),
        Lesson(.colours, "Yellow — Banana", "🍌", "This banana is yellow."),
        Lesson(.colours, "Green — Leaf", "🍃", "This leaf is green."),
        Lesson(.colours, "Orange — Fruit", "🍊", "This fruit is orange."),
        Lesson(.animals, "Lion", "🦁", "This is a lion. Listen to its roar!", sound: "A lion makes a roaring sound."),
        Lesson(.animals, "Elephant", "🐘", "This is an elephant. Look at its trunk!", sound: "An elephant makes a trumpeting sound."),
        Lesson(.animals, "Monkey", "🐒", "This is a monkey.", sound: "A monkey makes a chattering call."),
        Lesson(.animals, "Cat", "🐱", "This is a cat. It says meow.", sound: "Meow."),
        Lesson(.animals, "Dog", "🐶", "This is a dog. It says woof!", sound: "Woof!")
    ]
    // First ten questions and exact answer ordering come from the assignment content PDF.
    static let officialQuestions: [QuizQuestion] = [
        QuizQuestion("official-01", .abc, "Which word starts with A?", ["Apple", "Dog", "Cat"], "Apple", cue: "🍎", official: true),
        QuizQuestion("official-02", .abc, "Which letter comes after B?", ["A", "C", "E"], "C", cue: "A  B  ?", official: true),
        QuizQuestion("official-03", .numbers, "How many apples?", ["2", "3", "4"], "3", cue: "🍎 🍎 🍎", official: true),
        QuizQuestion("official-04", .numbers, "Which number is FIVE?", ["3", "5", "2"], "5", cue: "5️⃣", official: true),
        QuizQuestion("official-05", .colours, "Find the RED colour.", ["Blue", "Red", "Yellow"], "Red", cue: "🔴", official: true),
        QuizQuestion("official-06", .colours, "What colour is a banana?", ["Green", "Yellow", "Blue"], "Yellow", cue: "🍌", official: true),
        QuizQuestion("official-07", .animals, "Which animal is this?", ["Lion", "Cat", "Monkey"], "Lion", cue: "🦁", official: true),
        QuizQuestion("official-08", .animals, "Which animal says meow?", ["Dog", "Cat", "Elephant"], "Cat", cue: "🐱", official: true),
        QuizQuestion("official-09", .numbers, "Count the stars.", ["4", "5", "3"], "4", cue: "⭐️ ⭐️ ⭐️ ⭐️", official: true),
        QuizQuestion("official-10", .abc, "Which word starts with E?", ["Ball", "Elephant", "Dog"], "Elephant", cue: "🐘", official: true)
    ]
    // Additional original, curriculum-aligned exercises allow five *distinct* questions per category.
    static let extraQuestions: [QuizQuestion] = [
        QuizQuestion("extra-abc-01", .abc, "Which word starts with B?", ["Cat", "Ball", "Apple"], "Ball", cue: "⚽️"),
        QuizQuestion("extra-abc-02", .abc, "Which word starts with D?", ["Dog", "Cat", "Apple"], "Dog", cue: "🐕"),
        QuizQuestion("extra-abc-03", .abc, "Which letter is for Cat?", ["A", "C", "E"], "C", cue: "🐱"),
        QuizQuestion("extra-num-01", .numbers, "How many ducks?", ["2", "4", "1"], "2", cue: "🦆 🦆"),
        QuizQuestion("extra-num-02", .numbers, "Count the flowers.", ["3", "5", "2"], "5", cue: "🌼 🌼 🌼 🌼 🌼"),
        QuizQuestion("extra-num-03", .numbers, "How many balloons?", ["4", "2", "3"], "4", cue: "🎈 🎈 🎈 🎈"),
        QuizQuestion("extra-col-01", .colours, "What colour is this leaf?", ["Green", "Red", "Orange"], "Green", cue: "🍃"),
        QuizQuestion("extra-col-02", .colours, "What colour is the sky?", ["Yellow", "Blue", "Red"], "Blue", cue: "🌤️"),
        QuizQuestion("extra-col-03", .colours, "Which fruit is orange?", ["Banana", "Orange", "Apple"], "Orange", cue: "🍊"),
        QuizQuestion("extra-col-04", .colours, "What colour is the apple?", ["Red", "Blue", "Green"], "Red", cue: "🍎"),
        QuizQuestion("extra-ani-01", .animals, "Which animal has a trunk?", ["Monkey", "Elephant", "Cat"], "Elephant", cue: "🐘"),
        QuizQuestion("extra-ani-02", .animals, "Which animal says woof?", ["Dog", "Lion", "Cat"], "Dog", cue: "🐶"),
        QuizQuestion("extra-ani-03", .animals, "Which animal roars?", ["Lion", "Dog", "Monkey"], "Lion", cue: "🦁"),
        QuizQuestion("extra-ani-04", .animals, "Which animal is this?", ["Elephant", "Monkey", "Dog"], "Monkey", cue: "🐒")
    ]
    static var questions: [QuizQuestion] { officialQuestions + extraQuestions }
    static func lessons(for category: LearningCategory) -> [Lesson] { lessons.filter { $0.category == category } }
    static func questions(for category: LearningCategory?) -> [QuizQuestion] {
        guard let category else { return questions }
        return questions.filter { $0.category == category }
    }
}
