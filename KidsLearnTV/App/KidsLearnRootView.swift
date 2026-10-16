import SwiftUI

struct KidsLearnRootView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @StateObject private var speech = SpeechService()
    var body: some View {
        ZStack {
            TVTheme.background.ignoresSafeArea()
            RadialGradient(colors: [TVTheme.purple.opacity(0.16), .clear], center: .topTrailing,
                           startRadius: 40, endRadius: 1050).ignoresSafeArea()
            Group {
                switch store.screen {
                case .welcome: WelcomeTVView()
                case .menu: MainMenuTVView()
                case .learning: LessonTVView(speech: speech)
                case .quiz: QuizTVView(speech: speech)
                case .feedback: FeedbackTVView()
                case .results: ResultsTVView()
                case .rewards: RewardsTVView()
                }
            }.id("\(String(describing: store.screen))")
                .transition(.opacity.combined(with: .scale(scale: 0.985)))
                .animation(.easeOut(duration: 0.22), value: store.screen)
        }
        .environmentObject(speech)
        .preferredColorScheme(.dark)
        .alert("KidsLearn TV", isPresented: Binding(get: { store.errorMessage != nil }, set: { if !$0 { store.errorMessage = nil } })) {
            Button("Got It!") { store.errorMessage = nil }
        } message: { Text(store.errorMessage ?? "") }
    }
}
