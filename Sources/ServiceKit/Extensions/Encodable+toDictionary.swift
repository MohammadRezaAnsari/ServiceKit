//
//  Encodable+toDictionary.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation

public extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else { return nil }
        return dictionary
    }
}
