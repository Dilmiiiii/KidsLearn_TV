import SwiftUI

struct FeedbackTVView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @FocusState private var focus: String?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var burst = false
    var body: some View {
        if let round = store.round {
            VStack(spacing: 30) {
                Text(round.wasCorrect ? "🌟" : "💛").font(.system(size: 135))
                    .scaleEffect(burst && !reduceMotion ? 1.1 : 1)
                Text(round.wasCorrect ? "Great Job!" : "Good Try!")
                    .font(.system(size: 80, weight: .heavy, design: .rounded))
                Text(round.wasCorrect ? "You got it right!" : "Let's learn together.")
                    .font(.system(size: 42))
                Text(round.wasCorrect ? "+1 Star" : "The correct answer is \(round.activeQuestion.answer).")
                    .font(.system(size: 37, weight: .bold)).foregroundStyle(TVTheme.yellow)
                TVPrimaryButton(title: round.isFinalTurn ? "See My Results" : round.isLastQuestion && round.playerIndex == 0 && round.isTwoPlayer ? "Next Player" : "Next Question",
                                symbol: "arrow.right.circle.fill", focused: focus == "next", tint: TVTheme.teal) {
                    store.nextQuestion()
                }.focused($focus, equals: "next").frame(maxWidth: 590)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear { focus = "next"; withAnimation(.easeInOut(duration: 0.25)) { burst = true } }
                .onExitCommand { /* Feedback cannot be replayed to avoid duplicate scoring. */ }
        }
    }
}
