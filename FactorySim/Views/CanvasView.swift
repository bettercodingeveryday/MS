import SwiftUI

struct CanvasView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var simulationViewModel: SimulationViewModel
    @State private var canvasSize: CGSize = .zero

    var transform: WorldTransform {
        appViewModel.layout.calibration.screenTransform(canvasSize: canvasSize)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.gray.opacity(0.05))
                floorplanOverlay()
                edgeLayer()
                stationLayer()
                sketchLayer()
            }
            .onAppear { canvasSize = proxy.size }
            .onChange(of: proxy.size) { size in canvasSize = size }
            .background(Color.white)
            .border(Color.secondary.opacity(0.2))
        }
    }

    @ViewBuilder
    private func floorplanOverlay() -> some View {
        let size = CGSize(width: appViewModel.layout.floorplan.widthMeters, height: appViewModel.layout.floorplan.heightMeters)
        let screenSize = transform.worldToScreen(size: size)
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4]))
            .frame(width: screenSize.width, height: screenSize.height)
            .position(x: canvasSize.width / 2, y: canvasSize.height / 2)
            .overlay(alignment: .bottomTrailing) {
                Text("\(Int(size.width))m x \(Int(size.height))m")
                    .padding(6)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(6)
            }
    }

    @ViewBuilder
    private func stationLayer() -> some View {
        ForEach(appViewModel.layout.stations) { station in
            let position = transform.worldToScreen(station.position)
            let size = transform.worldToScreen(size: station.size)
            let selected = appViewModel.selectedStationId == station.id
            StationView(station: station, size: size, selected: selected)
                .position(position)
        }
    }

    @ViewBuilder
    private func edgeLayer() -> some View {
        ForEach(appViewModel.layout.edges) { edge in
            if let from = appViewModel.layout.stations.first(where: { $0.id == edge.from }),
               let to = appViewModel.layout.stations.first(where: { $0.id == edge.to }) {
                let start = transform.worldToScreen(from.position)
                let end = transform.worldToScreen(to.position)
                Path { path in
                    path.move(to: start)
                    path.addLine(to: end)
                }
                .stroke(Color.blue.opacity(0.4), style: StrokeStyle(lineWidth: 2, dash: [4]))
            }
        }
    }

    @ViewBuilder
    private func sketchLayer() -> some View {
        ForEach(appViewModel.layout.sketches) { sketch in
            Path { path in
                guard let first = sketch.points.first else { return }
                path.move(to: transform.worldToScreen(first))
                for point in sketch.points.dropFirst() {
                    path.addLine(to: transform.worldToScreen(point))
                }
            }
            .stroke(Color.orange.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

struct StationView: View {
    let station: StationInstance
    let size: CGSize
    let selected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(station.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: size.width, height: size.height)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selected ? Color.accentColor : Color.secondary.opacity(0.4), lineWidth: selected ? 3 : 1)
                )
        }
    }
}
