//
//  URLQuery.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation

public struct URLQuery: RawRepresentable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    static func + (lhs: URLQuery, rhs: URLQuery) -> URLQuery {
        return URLQuery(rawValue: lhs.rawValue + "&" + rhs.rawValue)
    }

    public static func / (lhs: URLQuery, rhs: URLQuery) -> URLQuery {
        return lhs + rhs
    }

    public static func / (lhs: URLQuery, rhs: String) -> URLQuery {
        return lhs + URLQuery(rawValue: rhs)
    }

    public var url: URL? {
        return URL(string: rawValue)
    }
}
