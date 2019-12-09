import XCTest

@testable import Networking

final class TaxClassRemoteTests: XCTestCase {

    /// Dummy Network Wrapper
    ///
    let network = MockupNetwork()

    /// Dummy Site ID
    ///
    let sampleSiteID: Int64 = 1234

    /// Repeat always!
    ///
    override func setUp() {
        super.setUp()
        network.removeAllSimulatedResponses()
    }

    // MARK: - Load all tax classes tests

    /// Verifies that loadAllTaxClasses properly parses the `taxes-classes` sample response.
    ///
    func testLoadAllTaxClassesProperlyReturnsParsedData() {
        let remote = TaxClassesRemote(network: network)
        let expectation = self.expectation(description: "Load All Tax Classes")

        network.simulateResponse(requestUrlSuffix: "taxes/classes", filename: "taxes-classes")

        remote.loadAllTaxClasses(for: sampleSiteID) { (taxClasses, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(taxClasses)
            XCTAssertEqual(taxClasses?.count, 3)
            
            // Validates on Tax Class with slug "standard"
            let expectedSlug = "standard"
            guard let expectedTaxClass = taxClasses?.first(where: { $0.slug == expectedSlug }) else {
                XCTFail("Tax Class with slug \(expectedSlug) should exist")
                return
            }
            XCTAssertEqual(expectedTaxClass.name, "Standard Rate")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: Constants.expectationTimeout)
    }

    /// Verifies that loadAllTaxClasses properly relays Networking Layer errors.
    ///
    func testLoadAllTaxClassesProperlyRelaysNetwokingErrors() {
        let remote = TaxClassesRemote(network: network)
        let expectation = self.expectation(description: "Load All Tax Classes returns error")

        remote.loadAllTaxClasses(for: sampleSiteID) { (taxClasses, error) in
            XCTAssertNil(taxClasses)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: Constants.expectationTimeout)
    }

}

private extension ProductVariationsRemoteTests {
    func dateFromGMT(_ dateStringInGMT: String) -> Date {
        let dateFormatter = DateFormatter.Defaults.dateTimeFormatter
        return dateFormatter.date(from: dateStringInGMT)!
    }
}
