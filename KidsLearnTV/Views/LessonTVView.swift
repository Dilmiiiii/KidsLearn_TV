import SwiftUI

struct LessonTVView: View {
    @EnvironmentObject private var store: KidsLearnStore
    @ObservedObject var speech: SpeechService
    @FocusState private var focus: String?
    @State private var speakSounds = false
    private var lesson: Lesson { store.currentLesson }
    private var last: Bool { store.lessonIndex == store.lessonCount - 1 }
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            TVStageBar(title: "\(store.category.title) / Lesson \(store.lessonIndex + 1)", detail: "\(store.lessonIndex + 1) of \(store.lessonCount)")
            Text("Let's learn together!").font(.system(size: 30, weight: .bold)).foregroundStyle(TVTheme.teal)
            HStack(spacing: 55) {
                ZStack {
                    RoundedRectangle(cornerRadius: 40).fill(TVTheme.accent(for: store.category).opacity(0.23))
                    VStack(spacing: 10) {
                        Text(lesson.visual).font(.system(size: 120)).lineLimit(2).minimumScaleFactor(0.48)
                            .frame(maxWidth: .infinity)
                        Text(lesson.title).font(.system(size: 45, weight: .heavy, design: .rounded))
                    }.padding(30)
                }.frame(maxWidth: .infinity).frame(height: 410)
                VStack(alignment: .leading, spacing: 25) {
                    Text(lesson.narration).font(.system(size: 42, weight: .bold, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                    if let sound = lesson.soundDescription {
                        Text("Sound note: \(sound)").font(.system(size: 24)).foregroundStyle(.white.opacity(0.7))
                        Text("Spoken description; not an animal recording.").font(.system(size: 19)).foregroundStyle(.white.opacity(0.55))
                    }
                    if speech.failed { Label("Sound is unavailable right now. You can still read and play!", systemImage: "speaker.slash")
                        .font(.system(size: 22)).foregroundStyle(TVTheme.yellow) }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(spacing: 15) {
                TVPrimaryButton(title: "Previous", symbol: "chevron.left", focused: focus == "previous") {
                    store.moveLesson(backward: true)
                }.focused($focus, equals: "previous").disabled(store.lessonIndex == 0)
                    .opacity(store.lessonIndex == 0 ? 0.4 : 1)
                TVPrimaryButton(title: "Hear Again", symbol: "speaker.wave.2.fill", focused: focus == "hear", tint: TVTheme.teal) {
                    speech.say(lesson.narration + (speakSounds ? " " + (lesson.soundDescription ?? "") : ""))
                }.focused($focus, equals: "hear")
                TVPrimaryButton(title: last ? "Finish Lesson" : "Next", symbol: "arrow.right.circle.fill", focused: focus == "next", tint: TVTheme.teal) {
                    store.moveLesson(backward: false)
                }.focused($focus, equals: "next")
            }
            HStack(spacing: 15) {
                TVPrimaryButton(title: "Try a Quiz", symbol: "questionmark.circle", focused: focus == "quiz", tint: TVTheme.yellow) {
                    speech.stop(); store.startQuiz(mode: .category(store.category))
                }.focused($focus, equals: "quiz")
                TVPrimaryButton(title: "Home", symbol: "house", focused: focus == "home") {
                    speech.stop(); store.goMenu()
                }.focused($focus, equals: "home")
            }
        }.padding(.horizontal, 88).padding(.vertical, 45)
            .onAppear { focus = "next"; speech.say(lesson.narration) }
            .onChange(of: store.lessonIndex) { _, _ in speech.say(lesson.narration) }
            .onExitCommand { speech.stop(); store.goMenu() }
    }
}
