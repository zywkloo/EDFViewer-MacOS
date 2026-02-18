#if canImport(SwiftUI)
import SwiftUI

struct WaveformMinMaxView: View {
    let waveform: MinMaxSeries

    var body: some View {
        Canvas { context, size in
            guard !waveform.mins.isEmpty, waveform.mins.count == waveform.maxs.count else {
                return
            }

            let globalMin = waveform.mins.min() ?? -1
            let globalMax = waveform.maxs.max() ?? 1
            let range = max(1e-6, globalMax - globalMin)

            let xStep = size.width / CGFloat(waveform.mins.count)
            var path = Path()

            for idx in waveform.mins.indices {
                let x = CGFloat(idx) * xStep
                let minY = size.height - CGFloat((waveform.mins[idx] - globalMin) / range) * size.height
                let maxY = size.height - CGFloat((waveform.maxs[idx] - globalMin) / range) * size.height
                path.move(to: CGPoint(x: x, y: minY))
                path.addLine(to: CGPoint(x: x, y: maxY))
            }

            context.stroke(path, with: .color(.accentColor), lineWidth: 1)
        }
        .background(Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
#endif
