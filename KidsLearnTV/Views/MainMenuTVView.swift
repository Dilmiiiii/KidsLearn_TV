import SwiftUI

struct MainMenuTVView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @FocusState private var focus: String?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                TVHeading(title: "Choose Your Learning Adventure!", subtitle: "Pick a world and discover something new.")
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], spacing: 26) {
                    ForEach(LearningCategory.allCases) { category in
                        Button { store.startLesson(category) } label: {
                            HStack(spacing: 30) {
                                Text(category.emblem).font(.system(size: 87))
                                VStack(alignment: .leading, spacing: 11) {
                                    Text(category.title).font(.system(size: 33, weight: .heavy, design: .rounded))
                                    Text(category.description).font(.system(size: 23))
                                        .foregroundStyle(.white.opacity(0.75)).fixedSize(horizontal: false, vertical: true)
                                    Text(category.cta + "  →").font(.system(size: 22, weight: .bold))
                                        .foregroundStyle(TVTheme.accent(for: category))
                                }
                                Spacer(minLength: 0)
                            }.frame(minHeight: 165, alignment: .leading)
                                .tvCard(focused: focus == category.id, tint: TVTheme.accent(for: category))
                        }.buttonStyle(.plain).focused($focus, equals: category.id)
                    }
                }
                HStack(spacing: 25) {
                    TVPrimaryButton(title: "Play Mixed Quiz", symbol: "questionmark.circle.fill", focused: focus == "quiz", tint: TVTheme.purple) {
                        store.startQuiz(mode: .mixed)
                    }.focused($focus, equals: "quiz")
                    TVPrimaryButton(title: "My Rewards", symbol: "star.fill", focused: focus == "rewards", tint: TVTheme.yellow) {
                        store.showRewards()
                    }.focused($focus, equals: "rewards")
                    TVPrimaryButton(title: "Two-Player Challenge", symbol: "person.2.fill", focused: focus == "family", tint: TVTheme.teal) {
                        store.startQuiz(mode: .twoPlayer)
                    }.focused($focus, equals: "family")
                }
                Text("Move with your remote and press Select to begin.").font(.system(size: 22)).foregroundStyle(.white.opacity(0.62))
            }.padding(.horizontal, 86).padding(.vertical, 55)
        }
        .onAppear { focus = LearningCategory.abc.id }
        .onExitCommand { store.screen = .welcome }
    }
}
