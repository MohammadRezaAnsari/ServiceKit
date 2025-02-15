//
//  Provider.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Alamofire
import Foundation

public typealias GenericResponse<T> = AFDataResponse<T>

public protocol ProviderType: AnyObject {
    associatedtype TargetType: Target
    func request<T: Decodable>(_ target: TargetType) async throws -> T
}

public class Provider<TargetType: Target>: ProviderType {
    public init() { }

    public func request<T: Decodable>(_ target: TargetType) async throws -> T {

        // Convert target to `URLRequest`
        var request = try target.toEndPoint()

        // Apply all preparation with plugins
        target.plugins.forEach { request = $0.prepare(request, target: target) }

        // Notify upper layer with plugins
        target.plugins.forEach { $0.willSend(request, target: target) }

        var response = await AF.request(request).validate().serializingDecodable(T.self, emptyResponseCodes: [200, 201, 204, 205]).response

        try await target.plugins.asyncForEach {
            response = try await $0.didReceive(response: response, target: target)
        }

        switch response.result {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
        }
    }
}
