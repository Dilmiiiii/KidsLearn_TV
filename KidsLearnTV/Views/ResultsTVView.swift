import SwiftUI

struct ResultsTVView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @FocusState private var focus: String?
    var body: some View {
        if let round = store.round {
            VStack(spacing: 24) {
                Text("🏆").font(.system(size: 110))
                Text(round.isTwoPlayer ? "Family Challenge Complete!" : "Amazing Work!")
                    .font(.system(size: 69, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                if round.isTwoPlayer {
                    Text("Player 1: \(round.scores[0]) correct     ·     Player 2: \(round.scores[1]) correct")
                        .font(.system(size: 38, weight: .bold))
                    Text(round.scores[0] == round.scores[1] ? "It's a tie!" :
                            "Player \(round.scores[0] > round.scores[1] ? 1 : 2) wins! Great playing together!")
                        .font(.system(size: 31)).foregroundStyle(TVTheme.teal)
                } else {
                    Text("You finished your learning adventure!").font(.system(size: 30)).foregroundStyle(.white.opacity(0.8))
                    Text("You scored \(round.scores[0]) out of \(round.questions.count).")
                        .font(.system(size: 39, weight: .bold))
                    Text("You earned \(round.scores[0]) stars!").font(.system(size: 34)).foregroundStyle(TVTheme.yellow)
                    HStack(spacing: 14) {
                        ForEach(0..<QuizRound.rating(for: round.scores[0], total: round.questions.count), id: \.self) { _ in
                            Image(systemName: "star.fill").font(.system(size: 49)).foregroundStyle(TVTheme.yellow)
                        }
                    }
                    Text(QuizRound.message(for: round.scores[0], total: round.questions.count))
                        .font(.system(size: 27)).foregroundStyle(.white.opacity(0.82))
                }
                HStack(spacing: 22) {
                    TVPrimaryButton(title: "Play Again", symbol: "arrow.clockwise", focused: focus == "replay", tint: TVTheme.teal) { store.replay() }
                        .focused($focus, equals: "replay")
                    if !round.isTwoPlayer {
                        TVPrimaryButton(title: "My Rewards", symbol: "star.fill", focused: focus == "rewards", tint: TVTheme.yellow) { store.showRewards() }
                            .focused($focus, equals: "rewards")
                    }
                    TVPrimaryButton(title: round.isTwoPlayer ? "Home" : "Back to Home", symbol: "house", focused: focus == "home") { store.goMenu() }
                        .focused($focus, equals: "home")
                }.padding(.top, 30)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.horizontal, 95)
                .onAppear { focus = "replay" }
                .onExitCommand { store.goMenu() }
        }
    }
}
