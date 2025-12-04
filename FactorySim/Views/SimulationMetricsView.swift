import SwiftUI

struct SimulationMetricsView: View {
    @EnvironmentObject private var simulationViewModel: SimulationViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Throughput")
                    .font(.caption)
                Text("\(simulationViewModel.engine.metrics.throughput) units")
                    .font(.title3)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Total WIP")
                    .font(.caption)
                Text("\(simulationViewModel.engine.metrics.totalWIP) parts")
                    .font(.title3)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Tick")
                    .font(.caption)
                Text("\(simulationViewModel.engine.metrics.tick)")
                    .font(.title3)
            }
            Spacer()
            Button("Step Simulation") {
                simulationViewModel.step()
            }
        }
    }
}

struct SimulationMetricsView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationMetricsView()
            .environmentObject(SimulationViewModel())
    }
}
