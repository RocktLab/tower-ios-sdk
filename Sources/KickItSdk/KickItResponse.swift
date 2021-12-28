import Foundation

public struct KickItResponse: Codable {
    public let message: String
    public let matched: Bool
    public let hardDeprecation: Bool?
    public let targetMeta: KickItTargetMeta?
}
