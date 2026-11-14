import Testing

@testable import ISO_11664

enum `ISO_11664.Tristimulus Tests` {}

extension `ISO_11664.Tristimulus Tests` {
    @Suite struct Test {
        @Suite struct Unit {}
    }
}

extension `ISO_11664.Tristimulus Tests`.Test.Unit {

    @Test
    func `one sample is the colour-matching functions times its power and the interval`() {
        let matching = ISO_11664.Observer.analytic.matching(at: 550)
        let values = ISO_11664.Tristimulus([2], from: 550, by: 5, observer: .analytic)
        #expect(values == ISO_11664.Tristimulus(x: 2 * matching.x * 5, y: 2 * matching.y * 5, z: 2 * matching.z * 5))
    }

    @Test
    func `samples are placed at the start plus their index times the interval`() {
        let values = ISO_11664.Tristimulus([0, 0, 1], from: 500, by: 10, observer: .analytic)
        let matching = ISO_11664.Observer.analytic.matching(at: 520)
        #expect(values == ISO_11664.Tristimulus(x: matching.x * 10, y: matching.y * 10, z: matching.z * 10))
    }

    @Test
    func `no power gives zero`() {
        #expect(ISO_11664.Tristimulus([], from: 360, by: 1, observer: .analytic) == .init(x: 0, y: 0, z: 0))
    }

    @Test
    func `the summation is linear in the power`() {
        let power = (0..<41).map { 0.5 + Double($0 % 7) / 7 }
        let once = ISO_11664.Tristimulus(power, from: 380, by: 10, observer: .analytic)
        let twice = ISO_11664.Tristimulus(power.map { $0 * 2 }, from: 380, by: 10, observer: .analytic)
        #expect(twice == ISO_11664.Tristimulus(x: once.x * 2, y: once.y * 2, z: once.z * 2))
    }
}
