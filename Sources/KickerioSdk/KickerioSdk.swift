import Alamofire
import Foundation

struct KickerioSdk {
    private static let baseURL = "http://localhost:3000"
    private static let apiKeyPlistKey = "kickerio_api_key"
    private static let appNamePlistKey = "CFBundleName"
    private static let appVersionPlistKey = "CFBundleShortVersionString"
    private static let buildNumberPlistKey = "CFBundleVersion"

    private let apiKey: String
    private let appName: String
    private let appVersion: String
    private let buildNumber: String
    private let platformVersion: String
    private let parameters: [String: String]

    convenience init(bundle: Bundle = Bundle.main,
                     processInfo: ProcessInfo = ProcessInfo.processInfo,
                     parameters: [String: String] = [:]) throws {
        let apiKey: String = try bundle.value(forKey: Self.apiKeyPlistKey)
        let appName: String = try bundle.value(forKey: Self.appNamePlistKey)
        let appVersion: String = try bundle.value(forKey: Self.appVersionPlistKey)
        let buildNumber: String = try bundle.value(forKey: Self.buildNumberPlistKey)
        let platformVersion: String = processInfo.operatingSystemVersionString
    }

    init(apiKey: String,
         appName: String,
         appVersion: String,
         buildNumber: String,
         platformVersion: String,
         parameters: [String: String]) {

    }

    func checkApplicationDeprecation(onComplete: @escaping (DataResponse<KickerioResponse, AFError>) -> ()) {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-API-KEY": apiKey,
            "X-KICKERIO-APP-NAME": appName,
            "X-KICKERIO-APP-VERSION": appVersion,
            "X-KICKERIO-BUILD-NUMBER": buildNumber,
            "X-KICKERIO-PLATFORM": "iOS",
            "X-KICKERIO-PLATFORM-OS-VERSION": platformVersion
        ]

        let parameters = [
            "data": parameters
        ]
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()

        AF.request(Self.baseURL + "/api/v1/target-checks", method: .post, parameters: parameters, headers: headers).responseDecodable(of: KickerioResponse.self, decoder: decoder) { response in
                onComplete(response as DataResponse<KickerioResponse, AFError>)
        }
    }
}

extension Bundle {
    enum Error: Swift.Error {
        case noValueFound
        case badType
    }

    func value<T>(forKey key: String) throws -> T {
        guard let value = object(forInfoDictionaryKey: key) else {
            throw Error.noValueFound
        }
        guard let coercedValue = value as? T else {
            throw Error.badType
        }
        return coercedValue
    }
}
