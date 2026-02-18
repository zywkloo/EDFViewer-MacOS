import Foundation

public struct EDFChannelInfo: Identifiable, Hashable {
    public let id: Int
    public let label: String
    public let unit: String
    public let sampleRate: Double

    public init(id: Int, label: String, unit: String, sampleRate: Double) {
        self.id = id
        self.label = label
        self.unit = unit
        self.sampleRate = sampleRate
    }
}

public struct EDFViewport: Hashable {
    public var startSecond: Double
    public var duration: Double

    public init(startSecond: Double, duration: Double) {
        self.startSecond = max(0, startSecond)
        self.duration = max(0.2, duration)
    }
}

public struct MinMaxSeries: Hashable {
    public let mins: [Float]
    public let maxs: [Float]

    public init(mins: [Float], maxs: [Float]) {
        self.mins = mins
        self.maxs = maxs
    }
}
