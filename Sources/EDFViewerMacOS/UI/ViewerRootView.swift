#if canImport(SwiftUI) && os(macOS)
import SwiftUI
import AppKit

struct ViewerRootView: View {
    @StateObject private var viewModel = ViewerViewModel()

    var body: some View {
        NavigationSplitView {
            List(viewModel.channels, selection: Binding(
                get: { viewModel.selectedChannel?.id },
                set: { newValue in
                    if let id = newValue {
                        viewModel.selectedChannel = viewModel.channels.first(where: { $0.id == id })
                        viewModel.refreshWaveform(pixelWidth: 1200)
                    }
                })
            ) { channel in
                VStack(alignment: .leading) {
                    Text(channel.label)
                    Text("\(Int(channel.sampleRate)) Hz • \(channel.unit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Channels")
        } detail: {
            VStack(spacing: 12) {
                HStack {
                    Button("Open EDF/BDF") { openPanel() }
                    Spacer()
                    Button("- Zoom") { viewModel.zoom(factor: 1.5) }
                    Button("+ Zoom") { viewModel.zoom(factor: 0.67) }
                    Button("←") { viewModel.pan(seconds: -viewModel.viewport.duration * 0.2) }
                    Button("→") { viewModel.pan(seconds: viewModel.viewport.duration * 0.2) }
                }

                WaveformMinMaxView(waveform: viewModel.waveform)
                    .frame(minHeight: 300)

                Text(viewModel.status)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("EDF Viewer")
        }
    }

    private func openPanel() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["edf", "bdf"]
        panel.begin { response in
            guard response == .OK, let url = panel.url else {
                return
            }
            viewModel.load(url: url)
        }
    }
}
#endif
