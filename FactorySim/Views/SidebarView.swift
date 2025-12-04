import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var appViewModel: AppViewModel

    var body: some View {
        List(selection: $appViewModel.selectedStationId) {
            Section("Stations") {
                ForEach(appViewModel.layout.stations) { station in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(station.name)
                        Text(station.modelId).font(.footnote).foregroundColor(.secondary)
                    }
                    .tag(station.id)
                }
            }

            Section("Station Library") {
                ForEach(appViewModel.layout.stationModels) { model in
                    HStack {
                        Circle().fill(Color(hex: model.colorHex)).frame(width: 10, height: 10)
                        Text(model.name)
                    }
                }
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(AppViewModel())
    }
}
