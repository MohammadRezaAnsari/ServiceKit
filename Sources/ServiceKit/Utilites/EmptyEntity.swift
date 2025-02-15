//
//  EmptyEntity.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation
import Alamofire

public struct EmptyEntity: Codable, EmptyResponse {
    public static func emptyValue() -> EmptyEntity {
        return EmptyEntity.init()
    }
}
