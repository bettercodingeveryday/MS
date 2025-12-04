import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var simulationViewModel: SimulationViewModel

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .frame(minWidth: 240)
        } detail: {
            VStack(spacing: 0) {
                CanvasView()
                    .environmentObject(appViewModel)
                    .environmentObject(simulationViewModel)
                Divider()
                SimulationMetricsView()
                    .environmentObject(simulationViewModel)
                    .padding()
            }
        }
        .onChange(of: appViewModel.layout) { layout in
            simulationViewModel.bind(to: layout)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppViewModel())
            .environmentObject(SimulationViewModel())
    }
}
