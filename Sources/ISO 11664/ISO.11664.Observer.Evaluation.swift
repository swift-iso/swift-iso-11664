extension ISO.`11664`.Observer {
    /// How an observer's colour-matching functions are evaluated.
    public enum Evaluation: Sendable, Hashable {
        /// The multi-lobe piecewise-Gaussian fit of Wyman, Sloan and Shirley, "Simple Analytic Approximations to
        /// the CIE XYZ Color Matching Functions", Journal of Computer Graphics Techniques 2(2), 2013. It
        /// approximates the standard's table and is not the standard's values: it is smooth, defined at every
        /// wavelength, and non-negative.
        case analytic
    }
}
