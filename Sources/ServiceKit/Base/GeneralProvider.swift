//
//  GeneralProvider.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Alamofire
import Foundation

/// - Warning: This class just only use for retrying purpose.
public class GeneralProvider {
    public init() { }

    public func request<T: Decodable>(_ request: URLRequest) async throws -> GenericResponse<T> {
        try await withUnsafeThrowingContinuation { continuation in

            // Send Request and decode it with defined decodable type
            AF.request(request).responseDecodable(of: T.self) { response in

                // Check for Request Error
                guard response.error == nil else { continuation.resume(throwing: response.error!); return }

                // Check response decoded value which should not be nil
                guard response.value != nil else { continuation.resume(throwing: ServiceError.emptyResult); return }

                // Return Response
                continuation.resume(returning: response)
            }
        }
    }
}
