import Foundation

protocol EDFReading {
    var channels: [ChannelInfo] { get }
    var fileDurationSeconds: Double { get }
    func readWindow(channelID: Int, startSeconds: Double, durationSeconds: Double) async throws -> WaveformWindow
}

enum EDFReaderFactory {
    static func makeReader(from url: URL) throws -> EDFReading {
        // Placeholder implementation that keeps the app functional while EDFlib
        // integration is added in a dedicated C/Swift bridging target.
        // Replace this with an EDFlib-backed reader once edflib.c/h are vendored.
        return MockEDFReader(fileURL: url)
    }
}

final class MockEDFReader: EDFReading {
    let channels: [ChannelInfo]
    let fileDurationSeconds: Double = 120

    init(fileURL: URL) {
        channels = [
            ChannelInfo(id: 0, label: "Fp1-F7", sampleRateHz: 256, unit: "uV"),
            ChannelInfo(id: 1, label: "F7-T3", sampleRateHz: 256, unit: "uV"),
            ChannelInfo(id: 2, label: "T3-T5", sampleRateHz: 256, unit: "uV")
        ]
    }

    func readWindow(channelID: Int, startSeconds: Double, durationSeconds: Double) async throws -> WaveformWindow {
        let sampleRate = channels.first(where: { $0.id == channelID })?.sampleRateHz ?? 256
        let sampleCount = max(1, Int(durationSeconds * sampleRate))
        var values = [Float]()
        values.reserveCapacity(sampleCount)

        for i in 0..<sampleCount {
            let t = Float(startSeconds + (Double(i) / sampleRate))
            let value = sinf(2 * .pi * 9 * t) * 45 + sinf(2 * .pi * 1.25 * t) * 10
            values.append(value)
        }

        return WaveformWindow(startSeconds: startSeconds, durationSeconds: durationSeconds, samples: values)
    }
}
