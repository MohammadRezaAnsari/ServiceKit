//
//  ServiceState.swift
//  
//
//  Created by Mohammad Reza Ansary on 12/22/1402 AP.
//

public enum ServiceState {
    case idle
    case inProgress
    case succeed
    case failed(Error)
}
