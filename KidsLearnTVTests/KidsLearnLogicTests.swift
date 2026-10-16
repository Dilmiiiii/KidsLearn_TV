import XCTest
@testable import KidsLearnTV

final class KidsLearnLogicTests: XCTestCase {
    func testAllContentLoadedAndOfficialQuestionsPreserved() {
        XCTAssertEqual(LearningContent.lessons.count, 20)
        XCTAssertEqual(LearningContent.officialQuestions.count, 10)
        for category in LearningCategory.allCases {
            XCTAssertEqual(LearningContent.lessons(for: category).count, 5)
            XCTAssertGreaterThanOrEqual(LearningContent.questions(for: category).count, 5)
        }
        XCTAssertEqual(LearningContent.officialQuestions[0].options, ["Apple", "Dog", "Cat"])
        XCTAssertEqual(LearningContent.officialQuestions[9].answer, "Elephant")
    }

    func testEveryCorrectAnswerIsAmongOptions() {
        XCTAssertTrue(LearningContent.questions.allSatisfy { $0.options.count == 3 && $0.options.contains($0.answer) })
        XCTAssertEqual(Set(LearningContent.questions.map(\.id)).count, LearningContent.questions.count)
    }

    func testQuizPreventsDuplicateScoring() {
        let questions = Array(LearningContent.officialQuestions.prefix(5))
        var round = QuizRound(mode: .mixed, questions: questions)
        XCTAssertTrue(round.submit(questions[0].answer))
        XCTAssertEqual(round.scores[0], 1)
        XCTAssertFalse(round.submit(questions[0].answer))
        XCTAssertEqual(round.scores[0], 1)
        round.advance()
        XCTAssertEqual(round.questionIndex, 1)
    }

    func testIncorrectAnswerDoesNotAddStars() {
        let questions = Array(LearningContent.officialQuestions.prefix(5))
        var round = QuizRound(mode: .mixed, questions: questions)
        let wrong = questions[0].options.first { $0 != questions[0].answer }!
        XCTAssertTrue(round.submit(wrong))
        XCTAssertEqual(round.currentScore, 0)
        XCTAssertFalse(round.wasCorrect)
    }

    func testTwoPlayerTurnOrderAndSeparateScores() {
        let questions = Array(LearningContent.officialQuestions.prefix(5))
        var round = QuizRound(mode: .twoPlayer, questions: questions)
        for question in questions {
            XCTAssertTrue(round.submit(question.answer))
            round.advance()
        }
        XCTAssertEqual(round.playerIndex, 1)
        XCTAssertEqual(round.questionIndex, 0)
        XCTAssertEqual(round.scores, [5, 0])
        for question in questions {
            XCTAssertTrue(round.submit(question.options.first { $0 != question.answer }!))
            round.advance()
        }
        XCTAssertTrue(round.completed)
        XCTAssertEqual(round.scores, [5, 0])
        XCTAssertEqual(round.totalCorrect, 5)
    }

    func testFiveQuestionRatings() {
        XCTAssertEqual(QuizRound.rating(for: 5, total: 5), 3)
        XCTAssertEqual(QuizRound.rating(for: 4, total: 5), 2)
        XCTAssertEqual(QuizRound.rating(for: 3, total: 5), 2)
        XCTAssertEqual(QuizRound.rating(for: 2, total: 5), 1)
        XCTAssertEqual(QuizRound.rating(for: 0, total: 5), 1)
    }

    func testBadgeUnlockOnlyAfterActuallyCompletingLessons() {
        var progress = LearningProgress()
        XCTAssertFalse(progress.badgeUnlocked("ABC Explorer"))
        progress.completedLessonIDs = Set(LearningContent.lessons(for: .abc).map(\.id))
        XCTAssertTrue(progress.badgeUnlocked("ABC Explorer"))
        XCTAssertFalse(progress.badgeUnlocked("Animal Friend"))
        XCTAssertFalse(progress.badgeUnlocked("Quiz Star"))
        progress.quizzesPlayed = 1
        XCTAssertTrue(progress.badgeUnlocked("Quiz Star"))
    }

    func testProgressPersistsAndResets() {
        let suite = "edu.sliit.tests.KidsLearnTV.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suite) else { XCTFail("Test defaults unavailable"); return }
        defer { defaults.removePersistentDomain(forName: suite) }
        let progress = LearningProgress(completedLessonIDs: ["abc|a — apple"], totalStars: 7, quizzesPlayed: 2, twoPlayerRounds: 1)
        ProgressPersistence.write(progress, defaults: defaults)
        XCTAssertEqual(ProgressPersistence.read(defaults: defaults), progress)
        ProgressPersistence.reset(defaults: defaults)
        XCTAssertEqual(ProgressPersistence.read(defaults: defaults), LearningProgress())
    }
}
