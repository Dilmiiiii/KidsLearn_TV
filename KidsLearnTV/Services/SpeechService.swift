import AVFoundation
import SwiftUI

@MainActor
final class SpeechService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let speech = AVSpeechSynthesizer()
    @Published var failed = false
    override init() { super.init(); speech.delegate = self }
    func say(_ text: String) {
        speech.stopSpeaking(at: .immediate)
        guard let voice = AVSpeechSynthesisVoice(language: "en-US") else { failed = true; return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice; utterance.rate = 0.45
        failed = false
        speech.speak(utterance)
    }
    func stop() { speech.stopSpeaking(at: .immediate) }
}
