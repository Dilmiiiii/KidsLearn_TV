# KidsLearn TV — Little Minds, Big Discoveries!

## Purpose and audience

Original tvOS educational SwiftUI prototype for ages 4–8, parents and families. All activities are designed for the **Apple TV Siri Remote**, not touch. Four worlds introduce first letters, numbers, colours and animals, then test knowledge with five-question quizzes and a shared-remote family challenge.

## Open on a Mac

Xcode 16, Apple TV simulator and XcodeGen are required.

```bash
brew install xcodegen
xcodegen generate
open KidsLearnTV.xcodeproj
xcodebuild -project KidsLearnTV.xcodeproj -scheme KidsLearnTV -sdk appletvsimulator -destination 'generic/platform=tvOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Choose an Apple TV simulator and run with Cmd-R. Use the simulator remote and Select/Back to navigate; do not use touch gestures. No network, account, SDK or external art download is needed.

## Source structure

- `App/`: tvOS `@main` App and seven-screen router.
- `Models/`: 20 exact specified lessons; 10 official quiz questions; original extra questions so all categories support five unique questions; a reusable and testable quiz round; Codable progress.
- `ViewModels/`: stateful shared GameStore for lesson progression, quiz submissions and rewards.
- `Services/`: AVSpeechSynthesizer English narration with on-screen captions and friendly unavailable state.
- `Views/`: Welcome, Main Menu, Learning, Quiz, Feedback, Results, Rewards.
- `Theme/` and `Components/`: colorful television-scale UI, focused-state scaling, card borders, buttons, headings.
- `KidsLearnTVTests/`, `KidsLearnTVUITests/`: content, scoring, persistence, two-player and remote smoke tests.

## Exact lesson content

ABC World: A–Apple, B–Ball, C–Cat, D–Dog, E–Elephant. Number Land: 1 star, 2 ducks, 3 apples, 4 balloons, 5 flowers. Colour Splash: red apple, blue sky, yellow banana, green leaf, orange fruit. Animal Kingdom: lion, elephant, monkey, cat, dog. Narrations reproduce the attached Part B content sheet; see `LearningContent.swift`.

## Main user journeys

1. Welcome → Start Learning → Main Menu → category → 5 lessons with Previous/Hear Again/Next/Finish Lesson, then quiz.
2. Main Menu → Mixed Quiz → choose from three focusable answers → Correct/Incorrect Feedback → five-question Results → Rewards.
3. Main Menu → Two-Player Challenge → Player 1 completes five questions → Player 2 receives **the same five questions** → scores are calculated independently → results with tie/winner handling.
4. My Rewards → persistent star total, finished lessons, quiz count and locked/unlocked achievements. The optional Reset Progress action requires confirmation.

## Scoring model

- Each correctly answered question earns **one point**, never twice; no points for an incorrect answer.
- At the end of a solo five-question round: five correct = 3 **rating** stars; three or four correct = 2; zero to two = 1. Rating stars are a display evaluation, not stored as earned quiz points.
- In two-player mode the same question set is given sequentially to both players using a single remote. All scores remain separate until the final comparison. Total earned quiz points are persisted only after the full round is completed.
- Category badges unlock only after all five category lessons have been completed, and Quiz Star after the first completed quiz.

## tvOS-specific behavior

- Native Button focus and `@FocusState` for default selection, strong active border, slight focus scale, Select/Back behavior, directional navigation and large 16:9 layout.
- All speech cues have visible matching captions. For animal sounds, the prototype uses **spoken descriptions**, not fake prerecorded animal samples. If speech voice availability fails, captions remain available.
- Child progress saved in UserDefaults using Codable, with no child account or data collection.

## Tests

```bash
xcodebuild -project KidsLearnTV.xcodeproj -scheme KidsLearnTV -destination 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation)' CODE_SIGNING_ALLOWED=NO test
```

Run on a device name installed in your Xcode. Unit tests cover all content, answer matching, unique question IDs, duplicate submissions, separate two-player scores, rating bands, badge unlocking, persistence and reset. The provided tvOS UI test verifies welcome-to-menu activation with the remote.

## Investor/pitch direction

KidsLearn TV is differentiated by offline, family-centered cooperative play in a living room. The business pitch in `../Assignment_Documentation/KidsLearnTV_Pitch.md` distinguishes a realistic product concept from unverified market-size projections and compares current alternatives with published sources.

## Five-minute viva demo

0:00 introduce couch learning + platform rationale; 0:40 remote focus and four categories; 1:20 ABC lesson and speech; 2:00 five-question quiz; 2:50 two-player turn separation; 4:10 reward badges/persistence; 4:35 business idea and ethical low-distraction design.

## Verification status

Swift-only lesson and quiz models were **actually compiled and executed on Linux**, including a two-player logic smoke test. The full tvOS app **was not compiled with Xcode or launched in an Apple TV simulator** in this environment. Confirm all focus directions, text sizing and startup audio before presenting the application.
