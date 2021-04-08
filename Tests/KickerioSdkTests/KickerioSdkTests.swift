import XCTest
import Alamofire
@testable import KickerioSdk

final class KickerioSdkTests: XCTestCase {
    func testAppTargetHit() {
        // Using version equals to 1.0.1 which is a target for the given key
        let kickerioSdk = KickerioSdk(apiKey: "6d71d7ebb9e2c0ed.dd24791ce6985c526497ec3fdcb4126521deff88f613db6680eea15a0d9f9b00",
                                      appName: "KickerApp",
                                      appVersion: "1.0.1",
                                      buildNumber: "20901",
                                      platformVersion: "10.4",
                                      parameters: [
                                        "someKey": "someValue",
                                        "moreArgs": "moreValues"
                                      ],
                                      urlSession: URLSession.shared)
        var kickerResponse: KickerioResponse?

        let exp = self.expectation(description: "KickerioSdk call")
        kickerioSdk.checkApplicationDeprecation { result in
            kickerResponse = try? result.get()
            
            XCTAssertEqual(kickerResponse?.matched, true)
            XCTAssertEqual(kickerResponse?.message, "Please update the app to the newest version on the App Store")
            XCTAssertEqual(kickerResponse?.hardDeprecation, true)

            XCTAssertNotNil(kickerResponse?.targetMeta)
            XCTAssertEqual(kickerResponse?.targetMeta?.appName, "KickerApp")
            XCTAssertEqual(kickerResponse?.targetMeta?.buildNumber, "20901")
            XCTAssertEqual(kickerResponse?.targetMeta?.platform, "ios")
            XCTAssertEqual(kickerResponse?.targetMeta?.version, "1.0.1")

            exp.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testAppTargetNotHit() {
        // Using version equals to 1.0.0 which is not a target for the given key
        let kickerioSdk = KickerioSdk(apiKey: "6d71d7ebb9e2c0ed.dd24791ce6985c526497ec3fdcb4126521deff88f613db6680eea15a0d9f9b00",
                                      appName: "KickerApp",
                                      appVersion: "1.0.0",
                                      buildNumber: "20901",
                                      platformVersion: "10.4",
                                      parameters: [
                                        "someKey": "someValue",
                                        "moreArgs": "moreValues"
                                      ],
                                      urlSession: URLSession.shared)

        let exp = expectation(description: "KickerioSdk call")
        kickerioSdk.checkApplicationDeprecation { result in
            debugPrint(result)
            
            let kickerResponse: KickerioResponse? = try? result.get()

            XCTAssertEqual(kickerResponse?.matched, false)
            XCTAssertEqual(kickerResponse?.message, "No app version matched")
            XCTAssertNil(kickerResponse?.hardDeprecation)
            XCTAssertNil(kickerResponse?.targetMeta)
            
            exp.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testPullingValuesFromBundle() {
        let testBundle = Bundle(for: type(of: self))
        let kickerioSdk = try! KickerioSdk(bundle: testBundle)
        XCTAssertEqual(kickerioSdk.apiKey, "1337")
        XCTAssertEqual(kickerioSdk.appName, "KickerioSdkTests")
        XCTAssertEqual(kickerioSdk.appVersion, "1.0")
        XCTAssertEqual(kickerioSdk.buildNumber, "1")
        XCTAssertEqual(kickerioSdk.platformVersion, ProcessInfo.processInfo.operatingSystemVersionString)
    }

    static var allTests = [
        ("testAppTargetHit", testAppTargetHit),
        ("testAppTargetNotHit", testAppTargetNotHit),
    ]
}
