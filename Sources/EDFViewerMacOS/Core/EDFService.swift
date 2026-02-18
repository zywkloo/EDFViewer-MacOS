import Foundation

protocol EDFService {
    var fileName: String { get }
    var channelCount: Int { get }
    var totalDuration: Double { get }

    func channelInfo(at index: Int) throws -> EDFChannelInfo
    func readSamples(channel index: Int, viewport: EDFViewport) throws -> [Float]
}

enum EDFServiceError: LocalizedError {
    case invalidChannel

    var errorDescription: String? {
        switch self {
        case .invalidChannel:
            return "Invalid channel index"
        }
    }
}

/// Placeholder implementation to keep the project runnable before wiring EDFlib.
final class MockEDFService: EDFService {
    let fileName: String
    let channelCount: Int
    let totalDuration: Double

    init(fileName: String = "Preview.edf", channelCount: Int = 8, totalDuration: Double = 120) {
        self.fileName = fileName
        self.channelCount = channelCount
        self.totalDuration = totalDuration
    }

    func channelInfo(at index: Int) throws -> EDFChannelInfo {
        guard index >= 0, index < channelCount else {
            throw EDFServiceError.invalidChannel
        }

        return EDFChannelInfo(
            id: index,
            label: "Ch\(index + 1)",
            unit: "uV",
            sampleRate: 256
        )
    }

    func readSamples(channel index: Int, viewport: EDFViewport) throws -> [Float] {
        let info = try channelInfo(at: index)
        let count = max(1, Int(viewport.duration * info.sampleRate))

        return (0..<count).map { sampleIndex in
            let t = viewport.startSecond + Double(sampleIndex) / info.sampleRate
            let base = sin(2 * Double.pi * (1.5 + Double(index) * 0.2) * t)
            let modulation = 0.35 * sin(2 * Double.pi * 0.2 * t)
            return Float((base + modulation) * 100)
        }
    }
}

/// Adapter shell where EDFlib integration should be implemented.
///
/// Replace method bodies with direct C calls from `edflib.h` once `edflib.c/.h`
/// are vendored into the Xcode project.
final class EDFLibService: EDFService {
    let fileName: String
    let channelCount: Int
    let totalDuration: Double

    init(url: URL) throws {
        // TODO: Open the EDF/BDF file through EDFlib.
        self.fileName = url.lastPathComponent
        self.channelCount = 0
        self.totalDuration = 0
    }

    func channelInfo(at index: Int) throws -> EDFChannelInfo {
        throw EDFServiceError.invalidChannel
    }

    func readSamples(channel index: Int, viewport: EDFViewport) throws -> [Float] {
        _ = viewport
        throw EDFServiceError.invalidChannel
    }
}
