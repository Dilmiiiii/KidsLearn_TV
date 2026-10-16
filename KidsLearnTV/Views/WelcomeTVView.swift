import SwiftUI

struct WelcomeTVView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @FocusState private var focus: String?
    @State private var instructions = false
    var body: some View {
        HStack(spacing: 75) {
            VStack(alignment: .leading, spacing: 24) {
                Label("KidsLearn TV", systemImage: "tv.fill")
                    .font(.system(size: 36, weight: .bold)).foregroundStyle(TVTheme.teal)
                Text("Little Minds, Big Discoveries!").font(.system(size: 30, weight: .semibold)).foregroundStyle(TVTheme.yellow)
                Text("Ready for a Fun\nLearning Adventure?")
                    .font(.system(size: 69, weight: .heavy, design: .rounded)).lineLimit(3)
                    .minimumScaleFactor(0.75)
                Text("Explore letters, numbers, colours and animals through playful activities.")
                    .font(.system(size: 27)).foregroundStyle(.white.opacity(0.76)).fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 20) {
                    TVPrimaryButton(title: "Start Learning", symbol: "play.fill", focused: focus == "start", tint: TVTheme.teal) {
                        store.goMenu()
                    }.focused($focus, equals: "start")
                    TVPrimaryButton(title: "How to Play", symbol: "questionmark.circle", focused: focus == "help") {
                        instructions = true
                    }.focused($focus, equals: "help")
                }.padding(.top, 18)
                Text("Made for little learners and family play.").font(.system(size: 21)).foregroundStyle(.white.opacity(0.56))
            }.frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 24) {
                Text("🌈").font(.system(size: 170))
                HStack(spacing: 20) {
                    Text("🔤"); Text("🔢")
                }.font(.system(size: 100))
                HStack(spacing: 20) { Text("🎨"); Text("🦁") }.font(.system(size: 100))
            }.frame(maxWidth: 540).padding(45)
                .background(TVTheme.panel, in: RoundedRectangle(cornerRadius: 52))
        }.padding(.horizontal, 92).padding(.vertical, 50)
            .onAppear { focus = "start" }
            .onExitCommand { if instructions { instructions = false } }
            .alert("How to Play", isPresented: $instructions) {
                Button("Got It!") { instructions = false }
            } message: {
                Text("Use your remote to move between choices. Press Select to choose an answer. Collect stars as you learn!")
            }
    }
}
