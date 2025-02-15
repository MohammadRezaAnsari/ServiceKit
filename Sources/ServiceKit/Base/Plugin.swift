//
//  Plugin.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation

public protocol Plugin {
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, target: Target) -> URLRequest

    /// Called immediately before a request is sent over the network.
    func willSend(_ request: URLRequest, target: Target)

    /// Called after a response has been received.
    func didReceive<T: Decodable>(response: GenericResponse<T>, target: Target) async throws -> GenericResponse<T>
}

public extension Plugin {
    func prepare(_ request: URLRequest, target: Target) -> URLRequest { request }
    func willSend(_ request: URLRequest, target: Target) { }
    func didReceive<T: Decodable>(response: GenericResponse<T>, target: Target) async throws -> GenericResponse<T> { response }
}
