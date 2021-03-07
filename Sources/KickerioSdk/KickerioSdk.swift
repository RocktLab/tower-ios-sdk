import Alamofire
import Foundation

struct KickerioSdk {
    let _base_url = "http://localhost:3000"

    func checkApplicationDeprecation(apiKey: String, userAgentString: String, parameters: [String: String], onComplete: @escaping (DataResponse<KickerioResponse, AFError>) -> ()) {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-API-KEY": apiKey,
            "User-Agent": userAgentString
        ]

        let parameters = [
            "data": parameters
        ]
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()

        AF.request(_base_url + "/api/v1/target-checks", method: .post, parameters: parameters, headers: headers).responseDecodable(of: KickerioResponse.self, decoder: decoder) { response in
                onComplete(response as DataResponse<KickerioResponse, AFError>)
        }
    }
}
