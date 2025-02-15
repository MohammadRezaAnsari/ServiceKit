//
//  Target.swift
//  
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation

public protocol Target {
    var URL: URLPath { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var plugins: [Plugin] { get }
}

public extension Target {
    var parameters: [String: Any]? { nil }
    var headers: [String: String]? { nil }
}


extension Target {
    func toEndPoint() throws -> URLRequest {

        // Create base form of URL
        guard let url = URL.url else { throw ServiceError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // Add defined headers to Request
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }

        // Add Body parameters to Request
        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }

        return request
    }
}
