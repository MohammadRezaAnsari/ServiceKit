//
//  Error.swift
//
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

import Foundation

public enum ServiceError: Error {
    case emptyData
    case emptyResult
    case invalidURL
    case invalidRequest
}
