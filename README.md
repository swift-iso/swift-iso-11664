# swift-iso-11664

Use this package when you need the CIE 1931 standard colorimetric observer's colour-matching functions x̄, ȳ and z̄ at a wavelength, or the CIE tristimulus values X, Y and Z of a sampled spectrum. Start from `` ISO.`11664`.Observer ``, evaluate it with `matching(at:)`, and sum a spectrum with `` ISO.`11664`.Tristimulus.init(_:from:by:observer:) ``. The standard's own table of the observer, at 1 nm from 360 to 830 nm, is not in this package yet: the only evaluation is `` ISO.`11664`.Observer.Evaluation.analytic ``, the multi-lobe fit of Wyman, Sloan and Shirley, "Simple Analytic Approximations to the CIE XYZ Color Matching Functions" (Journal of Computer Graphics Techniques 2(2), 2013), an approximation of the table and not its values. For converting tristimulus values to sRGB or other colour spaces, use swift-color-standard.

## Laws

- The table will come as a second case of `Evaluation`; code that names `.analytic` keeps the fit after that. The paper reports the fit's error against the 1931 table; this package repeats no accuracy figure it cannot check against the table.
- `matching(at:)` takes nanometres in air and returns x̄, ȳ and z̄ as the `x`, `y` and `z` of a `Tristimulus`: the values of a monochromatic stimulus of unit radiant power.
- The analytic fit is a sum of lobes `w · exp(−½ ((λ − μ) / σ)²)`, with one σ below the mean and another above: three lobes for x̄ (the third with a negative weight) and two each for ȳ and z̄, with the paper's constants to the digits it prints.
- The fit is defined at every wavelength. Outside 360 to 830 nm its values are its own tails, not the standard's.
- Over 360 to 830 nm the fit is never negative, ȳ peaks between 553 and 556 nm at 1 within 0.005, and summed at 1 nm each function comes to the integral of its lobes, w · √(π/2) · (σ₁ + σ₂) per lobe, about 106.9 for ȳ.
- `Tristimulus.init(_:from:by:observer:)` is the standard's summation with k = 1: X = Σ φ(λᵢ) x̄(λᵢ) Δλ, and Y and Z alike, with sample i at `start + i · interval` and Δλ the interval. It is linear in the power, and no power gives zero. Normalising by k, for example to Y = 100 for the illuminant, is the caller's.
- Tristimulus values carry no white point. What white they are relative to is the caller's to know.
