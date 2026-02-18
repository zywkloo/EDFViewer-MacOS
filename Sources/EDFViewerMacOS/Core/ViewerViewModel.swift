#if canImport(SwiftUI) && os(macOS)
import Foundation
import SwiftUI

@MainActor
final class ViewerViewModel: ObservableObject {
    @Published var channels: [EDFChannelInfo] = []
    @Published var selectedChannel: EDFChannelInfo?
    @Published var viewport = EDFViewport(startSecond: 0, duration: 10)
    @Published var waveform = MinMaxSeries(mins: [], maxs: [])
    @Published var status = "Open an EDF/BDF file to start"

    private var service: EDFService = MockEDFService()

    init() {
        loadChannelList()
        refreshWaveform(pixelWidth: 1200)
        status = "Loaded mock signal. Use File > Open to wire a real EDF file via EDFlib."
    }

    func load(url: URL) {
        do {
            service = try EDFLibService(url: url)
            viewport = EDFViewport(startSecond: 0, duration: 10)
            loadChannelList()
            refreshWaveform(pixelWidth: 1200)
            status = "Loaded \(service.fileName)"
        } catch {
            status = "Failed to load \(url.lastPathComponent): \(error.localizedDescription)"
        }
    }

    func pan(seconds: Double) {
        let maxStart = max(0, service.totalDuration - viewport.duration)
        viewport.startSecond = min(max(0, viewport.startSecond + seconds), maxStart)
        refreshWaveform(pixelWidth: 1200)
    }

    func zoom(factor: Double) {
        let current = viewport.duration
        let next = min(max(0.5, current * factor), max(0.5, service.totalDuration))
        viewport.duration = next
        pan(seconds: 0)
    }

    func refreshWaveform(pixelWidth: Int) {
        guard let channel = selectedChannel else {
            waveform = MinMaxSeries(mins: [], maxs: [])
            return
        }

        do {
            let raw = try service.readSamples(channel: channel.id, viewport: viewport)
            waveform = Downsampler.minMax(raw, bucketCount: max(64, pixelWidth))
        } catch {
            waveform = MinMaxSeries(mins: [], maxs: [])
            status = "Read failed: \(error.localizedDescription)"
        }
    }

    private func loadChannelList() {
        channels = (0..<service.channelCount).compactMap { index in
            try? service.channelInfo(at: index)
        }
        selectedChannel = channels.first
    }
}
#endif
