import Foundation

enum Downsampler {
    static func minMax(_ samples: [Float], bucketCount: Int) -> MinMaxSeries {
        guard !samples.isEmpty, bucketCount > 0 else {
            return MinMaxSeries(mins: [], maxs: [])
        }

        let step = max(1, samples.count / bucketCount)
        var mins: [Float] = []
        var maxs: [Float] = []
        mins.reserveCapacity(bucketCount)
        maxs.reserveCapacity(bucketCount)

        var i = 0
        while i < samples.count {
            let end = min(samples.count, i + step)
            var mn = samples[i]
            var mx = samples[i]
            if end - i > 1 {
                for sample in samples[(i + 1)..<end] {
                    mn = min(mn, sample)
                    mx = max(mx, sample)
                }
            }
            mins.append(mn)
            maxs.append(mx)
            i = end
        }

        return MinMaxSeries(mins: mins, maxs: maxs)
    }
}
