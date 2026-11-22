import ISO_9899_Core

extension ISO.`11664`.Observer {
    /// One lobe of the analytic fit: `weight · exp(−½ t²)` with `t = (λ − mean) / σ`, where σ is `below` for a
    /// wavelength under the mean and `above` otherwise.
    struct Lobe: Sendable {
        let weight: Double
        let mean: Double
        let below: Double
        let above: Double
    }
}

extension ISO.`11664`.Observer.Lobe {
    func callAsFunction(_ nanometres: Double) -> Double {
        let t = (nanometres - mean) / (nanometres < mean ? below : above)
        return weight * ISO.`9899`.Math.exp(-0.5 * t * t)
    }
}

extension ISO.`11664`.Observer.Lobe {
    /// x̄: three lobes, the third negative.
    static let x = (
        Self(weight: 1.056, mean: 599.8, below: 37.9, above: 31.0),
        Self(weight: 0.362, mean: 442.0, below: 16.0, above: 26.7),
        Self(weight: -0.065, mean: 501.1, below: 20.4, above: 26.2)
    )

    /// ȳ: two lobes.
    static let y = (
        Self(weight: 0.821, mean: 568.8, below: 46.9, above: 40.5),
        Self(weight: 0.286, mean: 530.9, below: 16.3, above: 31.1)
    )

    /// z̄: two lobes.
    static let z = (
        Self(weight: 1.217, mean: 437.0, below: 11.8, above: 36.0),
        Self(weight: 0.681, mean: 459.0, below: 26.0, above: 13.8)
    )
}
