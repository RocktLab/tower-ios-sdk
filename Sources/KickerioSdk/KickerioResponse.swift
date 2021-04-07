import Foundation

public struct KickerioResponse: Codable {
    let message: String
    let matched: Bool
    let hardDeprecation: Bool?
    let targetMeta: KickerioTargetMeta?
}
