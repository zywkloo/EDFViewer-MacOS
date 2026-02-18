#if canImport(SwiftUI) && os(macOS)
import SwiftUI

@main
struct EDFViewerMacOSApp: App {
    var body: some Scene {
        WindowGroup {
            ViewerRootView()
        }
        .windowResizability(.contentSize)
    }
}
#endif
