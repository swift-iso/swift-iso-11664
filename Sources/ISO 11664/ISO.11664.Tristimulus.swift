extension ISO.`11664` {
    /// CIE tristimulus values X, Y and Z (ISO/CIE 11664-3), as `x`, `y` and `z`.
    public struct Tristimulus: Sendable, Hashable {
        public var x: Double
        public var y: Double
        public var z: Double

        public init(x: Double, y: Double, z: Double) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
}

extension ISO.`11664`.Tristimulus {
    /// The tristimulus values of a spectral power distribution sampled at equal intervals, by the standard's
    /// summation with k = 1: X = Σ φ(λᵢ) x̄(λᵢ) Δλ, and Y and Z alike, where `power[i]` is φ at
    /// `start + i · interval` nanometres and Δλ is `interval`. No power gives zero. Scaling to a normalising k is
    /// the caller's.
    public init(
        _ power: some Swift.Sequence<Double>,
        from start: Double,
        by interval: Double,
        observer: ISO.`11664`.Observer
    ) {
        var sum = Self(x: 0, y: 0, z: 0)
        for (index, value) in power.enumerated() {
            let matching = observer.matching(at: start + Double(index) * interval)
            sum.x += value * matching.x * interval
            sum.y += value * matching.y * interval
            sum.z += value * matching.z * interval
        }
        self = sum
    }
}
