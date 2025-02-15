//
//  URLPath.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation

infix operator ~ : AdditionPrecedence
public struct URLPath: RawRepresentable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    static func + (lhs: URLPath, rhs: URLPath) -> URLPath {
        return URLPath(rawValue: lhs.rawValue + "/" + rhs.rawValue)
    }

    public static func / (lhs: URLPath, rhs: URLPath) -> URLPath {
        return lhs + rhs
    }

    public static func / (lhs: URLPath, rhs: String) -> URLPath {
        return lhs + URLPath(rawValue: rhs)
    }

    public static func ~ (lhs: URLPath, rhs: URLQuery) -> URLPath {
        return URLPath(rawValue: lhs.rawValue + "?" + rhs.rawValue)
    }

    public var url: URL? {
        return URL(string: rawValue)
    }
}
