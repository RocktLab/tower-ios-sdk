import Foundation

public struct KickItResponse: Codable {
    let message: String
    let matched: Bool
    let hardDeprecation: Bool?
    let targetMeta: KickItTargetMeta?
}
