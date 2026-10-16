import SwiftUI

@main
struct KidsLearnTVApp: App {
    @StateObject private var store = KidsLearnStore()
    var body: some Scene {
        WindowGroup { KidsLearnRootView().environmentObject(store) }
    }
}
