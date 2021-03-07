//
//  File.swift
//  
//
//  Created by Sebastian Jimenez on 6/03/21.
//

import Foundation

struct KickerioResponse: Decodable {
    let message: String
    let matched: Bool
    let targetMeta: KickerioTargetMeta?
}
