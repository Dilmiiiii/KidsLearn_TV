import SwiftUI

struct RewardsTVView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @FocusState private var focus: String?
    @State private var resetConfirm = false
    private let badges: [(name: String, message: String, icon: String)] = [
        ("ABC Explorer", "You discovered the letters!", "🔤"),
        ("Number Hero", "Counting champion!", "🔢"),
        ("Colour Artist", "You know your colours!", "🎨"),
        ("Animal Friend", "Wonderful animal explorer!", "🦁"),
        ("Quiz Star", "You completed a quiz!", "⭐️")
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 27) {
                TVHeading(title: "My Star Collection", subtitle: "Look at what you have learned!")
                HStack(spacing: 24) {
                    metric("Total Stars", "\(store.progress.totalStars)", "star.fill")
                    metric("Lessons Completed", "\(store.progress.completedLessonIDs.count)", "book.fill")
                    metric("Quizzes Played", "\(store.progress.quizzesPlayed)", "checkmark.seal.fill")
                }
                if store.progress.completedLessonIDs.isEmpty && store.progress.quizzesPlayed == 0 {
                    Text("Your adventure starts here! Play a lesson to earn your first star.")
                        .font(.system(size: 29)).foregroundStyle(TVTheme.teal)
                }
                Text("Your Badges").font(.system(size: 38, weight: .bold))
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 22) {
                    ForEach(badges, id: \.name) { badge in
                        let unlocked = store.progress.badgeUnlocked(badge.name)
                        VStack(alignment: .leading, spacing: 13) {
                            Text(unlocked ? badge.icon : "🔒").font(.system(size: 66))
                            Text(badge.name).font(.system(size: 28, weight: .bold))
                            Text(unlocked ? badge.message : "Keep playing to unlock this reward!")
                                .font(.system(size: 20)).foregroundStyle(.white.opacity(0.69))
                        }.frame(maxWidth: .infinity, minHeight: 155, alignment: .leading)
                            .padding(24).background(TVTheme.panel, in: RoundedRectangle(cornerRadius: 25))
                            .opacity(unlocked ? 1 : 0.63)
                    }
                }
                HStack(spacing: 22) {
                    TVPrimaryButton(title: "Play More", symbol: "play", focused: focus == "play", tint: TVTheme.teal) { store.goMenu() }
                        .focused($focus, equals: "play")
                    TVPrimaryButton(title: "Back to Home", symbol: "house", focused: focus == "home") { store.goMenu() }
                        .focused($focus, equals: "home")
                    TVPrimaryButton(title: "Reset Progress", symbol: "arrow.counterclockwise", focused: focus == "reset", tint: TVTheme.pink) {
                        resetConfirm = true
                    }.focused($focus, equals: "reset")
                }
            }.padding(.horizontal, 86).padding(.vertical, 50)
        }
        .onAppear { focus = "play" }
        .onExitCommand { store.goMenu() }
        .alert("Reset Progress?", isPresented: $resetConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                ProgressPersistence.reset()
                store.progress = LearningProgress()
            }
        } message: { Text("This will erase earned stars, lessons and quiz records on this Apple TV.") }
    }
    private func metric(_ name: String, _ value: String, _ symbol: String) -> some View {
        HStack(spacing: 22) {
            Image(systemName: symbol).font(.system(size: 46)).foregroundStyle(TVTheme.yellow)
            VStack(alignment: .leading, spacing: 7) {
                Text(value).font(.system(size: 43, weight: .heavy))
                Text(name).font(.system(size: 22)).foregroundStyle(.white.opacity(0.7))
            }
            Spacer(minLength: 0)
        }.tvCard(focused: false, tint: TVTheme.teal)
    }
}
