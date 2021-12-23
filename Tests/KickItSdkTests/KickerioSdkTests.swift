import XCTest
@testable import KickItSdk

final class KickItSdkTests: XCTestCase {
    func testAppTargetHit() {
        // Using version equals to 1.0.1 which is a target for the given key
        let kickItSdk = KickItSdk(apiKey: "1637dbd79b64f067.ff3697cffb3537e11abfb81c0d9252f4f20155c306955bc9d7de96982305ffb9",
                                      appName: "KickerApp",
                                      appVersion: "1.0.1",
                                      buildNumber: "20901",
                                      platformVersion: "10.4",
                                      parameters: [
                                        "someKey": "someValue",
                                        "moreArgs": "moreValues"
                                      ],
                                      urlSession: URLSession.shared)
        var kickItResponse: KickItResponse?

        let exp = self.expectation(description: "KickerioSdk call")
        kickItSdk.checkApplicationDeprecation { result in
            kickItResponse = try? result.get()

            XCTAssertEqual(kickItResponse?.matched, true)
            XCTAssertEqual(kickItResponse?.message, "Please update the app to the newest version on the App Store")
            XCTAssertEqual(kickItResponse?.hardDeprecation, true)

            XCTAssertNotNil(kickItResponse?.targetMeta)
            XCTAssertEqual(kickItResponse?.targetMeta?.appName, "KickerApp")
            XCTAssertEqual(kickItResponse?.targetMeta?.buildNumber, "20901")
            XCTAssertEqual(kickItResponse?.targetMeta?.platform, "ios")
            XCTAssertEqual(kickItResponse?.targetMeta?.version, "1.0.1")

            exp.fulfill()
        }

        wait(for: [exp], timeout: 3.0)
    }

    func testAppTargetNotHit() {
        // Using version equals to 1.0.0 which is not a target for the given key
        let kickItSdk = KickItSdk(apiKey: "1637dbd79b64f067.ff3697cffb3537e11abfb81c0d9252f4f20155c306955bc9d7de96982305ffb9",
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
        kickItSdk.checkApplicationDeprecation { result in
            debugPrint(result)
            
            let kickItResponse: KickItResponse? = try? result.get()

            XCTAssertEqual(kickItResponse?.matched, false)
            XCTAssertEqual(kickItResponse?.message, "No app version matched")
            XCTAssertNil(kickItResponse?.hardDeprecation)
            XCTAssertNil(kickItResponse?.targetMeta)
            
            exp.fulfill()
        }

        wait(for: [exp], timeout: 3.0)
    }

    func testPullingValuesFromBundle() {
        let testBundle = Bundle(for: type(of: self))
        let kickItSdk = try! KickItSdk(bundle: testBundle)
        XCTAssertEqual(kickItSdk.apiKey, "1337")
        XCTAssertEqual(kickItSdk.appName, "KickItSdkTests")
        XCTAssertEqual(kickItSdk.appVersion, "1.0")
        XCTAssertEqual(kickItSdk.buildNumber, "1")
        XCTAssertEqual(kickItSdk.platformVersion, ProcessInfo.processInfo.operatingSystemVersionString)
    }

    static var allTests = [
        ("testAppTargetHit", testAppTargetHit),
        ("testAppTargetNotHit", testAppTargetNotHit),
    ]
}
