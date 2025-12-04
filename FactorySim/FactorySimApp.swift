import SwiftUI

@main
struct FactorySimApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var simulationViewModel = SimulationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(simulationViewModel)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Load Sample Layout") {
                    appViewModel.loadSampleLayout()
                }
            }
        }
    }
}
