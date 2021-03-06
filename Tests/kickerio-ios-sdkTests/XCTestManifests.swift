import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(kickerio_ios_sdkTests.allTests),
    ]
}
#endif
