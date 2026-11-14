import ISO_9899_Core
import Testing

@testable import ISO_11664

enum `ISO_11664.Observer Tests` {}

extension `ISO_11664.Observer Tests` {
    @Suite struct Test {
        @Suite struct Unit {}
    }
}

extension `ISO_11664.Observer Tests`.Test.Unit {

    /// Every wavelength of the standard's range, 360 to 830 nm, at 0.01 nm.
    static let range = (0...47_000).map { 360 + Double($0) / 100 }

    @Test
    func `the luminous efficiency function peaks near 555 nanometres at about 1`() {
        let observer = ISO_11664.Observer.analytic
        let peak = Self.range.max { observer.matching(at: $0).y < observer.matching(at: $1).y }!
        #expect((553...556).contains(peak))
        #expect(abs(observer.matching(at: peak).y - 1) < 0.005)
    }

    @Test
    func `the colour-matching functions are never negative over the standard's range`() {
        let observer = ISO_11664.Observer.analytic
        for wavelength in Self.range {
            let matching = observer.matching(at: wavelength)
            #expect(matching.x >= 0 && matching.y >= 0 && matching.z >= 0, "at \(wavelength) nm")
        }
    }

    @Test
    func `the sum of each function at 1 nanometre is the integral of its lobes`() {
        // A lobe w·exp(−½((λ−μ)/σ)²), with σ₁ below the mean and σ₂ above, integrates over the whole line to
        // w·√(π/2)·(σ₁ + σ₂); the tails outside 360 to 830 nm are below 0.003 of the total.
        let half = (Double.pi / 2).squareRoot()
        let x = half * (1.056 * (37.9 + 31.0) + 0.362 * (16.0 + 26.7) - 0.065 * (20.4 + 26.2))
        let y = half * (0.821 * (46.9 + 40.5) + 0.286 * (16.3 + 31.1))
        let z = half * (1.217 * (11.8 + 36.0) + 0.681 * (26.0 + 13.8))
        let sum = ISO_11664.Tristimulus(
            [Double](repeating: 1, count: 471),
            from: 360,
            by: 1,
            observer: .analytic
        )
        #expect(abs(sum.x - x) < 0.003)
        #expect(abs(sum.y - y) < 0.003)
        #expect(abs(sum.z - z) < 0.003)
        #expect(abs(y - 106.922) < 0.001)
    }

    @Test
    func `an equal-energy spectrum has nearly equal X, Y and Z`() {
        let sum = ISO_11664.Tristimulus(
            [Double](repeating: 1, count: 471),
            from: 360,
            by: 1,
            observer: .analytic
        )
        #expect(abs(sum.x / sum.y - 1) < 0.002)
        #expect(abs(sum.z / sum.y - 1) < 0.002)
    }

    @Test
    func `the fit is the multi-lobe formula as written in the paper, bit for bit`() {
        // The formula written out once more, independently of the lobe table, at the midpoints of 2 to 32 equal
        // parts of 400 to 700 nm and at whole nanometres from 360 to 830.
        func lobe(_ wavelength: Double, _ mean: Double, _ below: Double, _ above: Double) -> Double {
            let t = (wavelength - mean) / (wavelength < mean ? below : above)
            return ISO_9899.Math.exp(-0.5 * t * t)
        }
        func reference(_ w: Double) -> (Double, Double, Double) {
            (
                1.056 * lobe(w, 599.8, 37.9, 31.0) + 0.362 * lobe(w, 442.0, 16.0, 26.7)
                    - 0.065 * lobe(w, 501.1, 20.4, 26.2),
                0.821 * lobe(w, 568.8, 46.9, 40.5) + 0.286 * lobe(w, 530.9, 16.3, 31.1),
                1.217 * lobe(w, 437.0, 11.8, 36.0) + 0.681 * lobe(w, 459.0, 26.0, 13.8)
            )
        }
        let midpoints = (2...32).flatMap { count in
            (0..<count).map { 400 + 300 * (Double($0) + 0.5) / Double(count) }
        }
        let whole = (360...830).map(Double.init)
        for wavelength in midpoints + whole {
            let matching = ISO_11664.Observer.analytic.matching(at: wavelength)
            let expected = reference(wavelength)
            #expect(matching.x == expected.0 && matching.y == expected.1 && matching.z == expected.2)
        }
    }
}
