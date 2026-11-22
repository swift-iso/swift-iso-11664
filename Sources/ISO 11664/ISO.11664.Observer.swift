extension ISO.`11664` {
    /// The CIE 1931 standard colorimetric observer, 2° field (ISO/CIE 11664-1): the colour-matching functions
    /// x̄, ȳ and z̄ of a wavelength, evaluated as `evaluation` says.
    public struct Observer: Sendable, Hashable {
        /// How the colour-matching functions are evaluated.
        public var evaluation: Evaluation

        public init(evaluation: Evaluation) {
            self.evaluation = evaluation
        }
    }
}

extension ISO.`11664`.Observer {
    /// The observer evaluated by the analytic approximation of Wyman, Sloan and Shirley (2013).
    public static let analytic = Self(evaluation: .analytic)
}

extension ISO.`11664`.Observer {
    /// The colour-matching functions at a wavelength in nanometres, as tristimulus values: those of a
    /// monochromatic stimulus of unit radiant power at that wavelength, with x̄ as `x`, ȳ as `y` and z̄ as `z`.
    public func matching(at nanometres: Double) -> ISO.`11664`.Tristimulus {
        switch evaluation {
        case .analytic:
            ISO.`11664`.Tristimulus(
                x: Lobe.x.0(nanometres) + Lobe.x.1(nanometres) + Lobe.x.2(nanometres),
                y: Lobe.y.0(nanometres) + Lobe.y.1(nanometres),
                z: Lobe.z.0(nanometres) + Lobe.z.1(nanometres)
            )
        }
    }
}
