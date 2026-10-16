import SwiftUI

struct QuizTVView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @ObservedObject var speech: SpeechService
    @FocusState private var focus: String?
    @State private var exitConfirm = false
    var body: some View {
        if let round = store.round {
            VStack(alignment: .leading, spacing: 26) {
                TVStageBar(title: "Time to Play!", detail: "Question \(round.questionIndex + 1) of \(round.questions.count)   ·   Stars Earned: \(round.currentScore)")
                if round.isTwoPlayer {
                    Label("Player \(round.playerIndex + 1)'s Turn", systemImage: "person.fill")
                        .font(.system(size: 36, weight: .bold)).foregroundStyle(TVTheme.teal)
                }
                Text("Choose the correct answer using your remote.")
                    .font(.system(size: 27)).foregroundStyle(.white.opacity(0.7))
                HStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(round.activeQuestion.question).font(.system(size: 54, weight: .heavy, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        if !round.activeQuestion.cue.isEmpty {
                            Text(round.activeQuestion.cue).font(.system(size: 86)).minimumScaleFactor(0.6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 19) {
                        ForEach(Array(round.activeQuestion.options.enumerated()), id: \.offset) { index, option in
                            Button { store.answer(option) } label: {
                                HStack {
                                    Text("\(index + 1)").font(.system(size: 28, weight: .bold))
                                        .frame(width: 45, height: 45)
                                        .background(TVTheme.purple, in: Circle())
                                    Text(option).font(.system(size: 36, weight: .bold))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }.frame(minHeight: 67)
                                    .tvCard(focused: focus == "answer-\(index)", tint: TVTheme.teal)
                            }.buttonStyle(.plain).disabled(round.answerLocked).focused($focus, equals: "answer-\(index)")
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(maxHeight: .infinity)
                HStack(spacing: 22) {
                    TVPrimaryButton(title: "Hear Question", symbol: "speaker.wave.2", focused: focus == "hear") {
                        speech.say(round.activeQuestion.question)
                    }.focused($focus, equals: "hear")
                    TVPrimaryButton(title: "Exit Quiz", symbol: "xmark.circle", focused: focus == "exit", tint: TVTheme.pink) {
                        exitConfirm = true
                    }.focused($focus, equals: "exit")
                }
            }.padding(.horizontal, 88).padding(.vertical, 43)
                .onAppear { focus = "answer-0"; speech.say(round.activeQuestion.question) }
                .onExitCommand { exitConfirm = true }
                .alert("Leave this quiz?", isPresented: $exitConfirm) {
                    Button("Stay", role: .cancel) { exitConfirm = false }
                    Button("Leave", role: .destructive) { speech.stop(); store.abandonQuiz() }
                } message: { Text("Leave this quiz? Your current round will not be saved.") }
        }
    }
}
