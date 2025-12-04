import XCTest
@testable import FactorySim

final class FactorySimTests: XCTestCase {
    func testEdgeIdParsing() {
        XCTAssertEqual(Edge.parseIdentifier("A-B")?.0, "A")
        XCTAssertEqual(Edge.parseIdentifier("A-B")?.1, "B")
        XCTAssertNil(Edge.parseIdentifier("invalid"))
    }

    func testLayoutJSONRoundTrip() throws {
        let layout = FactoryLayout.sample()
        let data = try LayoutIO.sampleJSON()
        let decoded = try JSONDecoder().decode(FactoryLayout.self, from: data)
        XCTAssertEqual(layout.stationModels.count, decoded.stationModels.count)
        XCTAssertEqual(layout.edges.count, decoded.edges.count)
    }

    func testSimulationStepAdvancesThroughput() {
        let layout = FactoryLayout.sample()
        let engine = SimulationEngine(layout: layout)
        engine.step(delta: 12)
        XCTAssertGreaterThan(engine.metrics.throughput, 0)
        XCTAssertGreaterThanOrEqual(engine.metrics.totalWIP, engine.metrics.throughput)
    }
}
