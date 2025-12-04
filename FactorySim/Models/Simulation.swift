import Foundation
import Combine
import CoreGraphics

struct StationState: Identifiable, Codable, Equatable {
    var id: String
    var wip: Int
    var completed: Int
    var remaining: TimeInterval

    static func initial(id: String) -> StationState {
        StationState(id: id, wip: 0, completed: 0, remaining: 0)
    }
}

struct SimulationMetrics: Codable, Equatable {
    var throughput: Int
    var totalWIP: Int
    var tick: Int
}

final class SimulationEngine: ObservableObject {
    @Published private(set) var state: [StationState]
    @Published private(set) var metrics: SimulationMetrics

    private let layout: FactoryLayout

    init(layout: FactoryLayout) {
        self.layout = layout
        self.state = layout.stations.map { StationState.initial(id: $0.id) }
        self.metrics = SimulationMetrics(throughput: 0, totalWIP: 0, tick: 0)
    }

    func step(delta: TimeInterval = 1.0) {
        metrics.tick += 1
        var completedNow = 0

        for index in state.indices {
            var stationState = state[index]
            let stationModel = layout.stationModels.first { $0.id == layout.stations[index].modelId }
            guard let model = stationModel else { continue }

            if stationState.wip < model.wipLimit {
                stationState.wip += 1
                metrics.totalWIP += 1
                stationState.remaining = model.cycleTime
            }

            if stationState.remaining > 0 {
                stationState.remaining -= delta
                if stationState.remaining <= 0 {
                    stationState.wip = max(0, stationState.wip - 1)
                    stationState.completed += 1
                    completedNow += 1
                }
            }
            state[index] = stationState
        }

        metrics.throughput += completedNow
    }
}
