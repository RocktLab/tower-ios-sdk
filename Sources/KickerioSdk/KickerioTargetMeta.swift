//
//  File.swift
//  
//
//  Created by Sebastian Jimenez on 6/03/21.
//

import Foundation

struct KickerioTargetMeta: Decodable {
    let version: String
    let buildNumber: String
    let hardDeprecation: Bool
    let platform: String
    let appName: String
}
