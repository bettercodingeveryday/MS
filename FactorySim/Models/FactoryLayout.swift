import Foundation
import CoreGraphics

struct Floorplan: Codable, Equatable {
    var imageName: String
    var widthMeters: CGFloat
    var heightMeters: CGFloat
}

struct Calibration: Codable, Equatable {
    var origin: CGPoint // world origin in image coordinates
    var metersPerPoint: CGFloat

    func screenTransform(canvasSize: CGSize) -> WorldTransform {
        WorldTransform(origin: origin, scale: 1.0 / metersPerPoint, canvasSize: canvasSize)
    }
}

struct StationModel: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var cycleTime: TimeInterval
    var wipLimit: Int
    var colorHex: String

    static let demoModels: [StationModel] = [
        StationModel(id: "assembly", name: "Assembly", cycleTime: 12, wipLimit: 6, colorHex: "#4E8BED"),
        StationModel(id: "inspection", name: "Inspection", cycleTime: 6, wipLimit: 3, colorHex: "#FFB347"),
        StationModel(id: "packout", name: "Packout", cycleTime: 8, wipLimit: 4, colorHex: "#2ECC71")
    ]
}

struct StationInstance: Codable, Identifiable, Equatable {
    var id: String
    var modelId: String
    var name: String
    var position: CGPoint
    var size: CGSize
}

struct Edge: Codable, Identifiable, Equatable {
    var id: String { "\(from)-\(to)" }
    var from: String
    var to: String
    var transportTime: TimeInterval
    var capacity: Int

    static func parseIdentifier(_ id: String) -> (String, String)? {
        let parts = id.split(separator: "-")
        guard parts.count == 2 else { return nil }
        return (String(parts[0]), String(parts[1]))
    }
}

struct Sketch: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var points: [CGPoint]
}

struct FactoryLayout: Codable, Equatable {
    var floorplan: Floorplan
    var calibration: Calibration
    var stationModels: [StationModel]
    var stations: [StationInstance]
    var edges: [Edge]
    var sketches: [Sketch]

    static func sample() -> FactoryLayout {
        FactoryLayout(
            floorplan: Floorplan(imageName: "floorplan-placeholder", widthMeters: 60, heightMeters: 30),
            calibration: Calibration(origin: CGPoint(x: 0, y: 0), metersPerPoint: 0.1),
            stationModels: StationModel.demoModels,
            stations: [
                StationInstance(id: "S1", modelId: "assembly", name: "Assembly 1", position: CGPoint(x: 5, y: 5), size: CGSize(width: 4, height: 3)),
                StationInstance(id: "S2", modelId: "inspection", name: "Inspection 1", position: CGPoint(x: 15, y: 5), size: CGSize(width: 3, height: 2)),
                StationInstance(id: "S3", modelId: "packout", name: "Packout", position: CGPoint(x: 25, y: 5), size: CGSize(width: 4, height: 3))
            ],
            edges: [
                Edge(from: "S1", to: "S2", transportTime: 2, capacity: 3),
                Edge(from: "S2", to: "S3", transportTime: 2, capacity: 3)
            ],
            sketches: [Sketch(points: [CGPoint(x: 0, y: 0), CGPoint(x: 10, y: 0), CGPoint(x: 10, y: 10)])]
        )
    }
}
