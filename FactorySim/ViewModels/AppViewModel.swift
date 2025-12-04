import Foundation
import Combine
import CoreGraphics

final class AppViewModel: ObservableObject {
    @Published var layout: FactoryLayout
    @Published var selectedStationId: String?

    init(layout: FactoryLayout = FactoryLayout.sample()) {
        self.layout = layout
    }

    func loadSampleLayout() {
        layout = FactoryLayout.sample()
    }

    func update(station: StationInstance) {
        guard let index = layout.stations.firstIndex(where: { $0.id == station.id }) else { return }
        layout.stations[index] = station
    }

    func addStation(modelId: String, at point: CGPoint) {
        let newStation = StationInstance(
            id: UUID().uuidString,
            modelId: modelId,
            name: "Station \(layout.stations.count + 1)",
            position: point,
            size: CGSize(width: 3, height: 2)
        )
        layout.stations.append(newStation)
    }
}

final class SimulationViewModel: ObservableObject {
    @Published private(set) var engine: SimulationEngine

    init(layout: FactoryLayout = FactoryLayout.sample()) {
        self.engine = SimulationEngine(layout: layout)
    }

    func bind(to layout: FactoryLayout) {
        engine = SimulationEngine(layout: layout)
    }

    func step() {
        engine.step()
    }
}
