### ServiceKit

A lightweight, plugin-based Swift networking layer built on top of Alamofire that simplifies API calls and provides powerful middleware capabilities.

[![Swift Version](https://img.shields.io/badge/Swift-6.2+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-lightgrey.svg)](https://developer.apple.com/ios/)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)
[![Latest Release](https://img.shields.io/badge/Release-0.1.11-important)](https://github.com/MohammadRezaAnsari/ServiceKit/releases)

## Overview

ServiceKit provides a clean, protocol-oriented architecture for managing network requests in iOS applications. It abstracts away the complexity of direct networking calls while offering extensibility through a plugin system that acts as middleware for request/response lifecycle events.

## Key Features

- **🎯 Protocol-Oriented Design**: Define API endpoints using the `Target` protocol
- **🔌 Plugin Architecture**: Inject custom behavior before/after network calls
- **⚡️ Async/Await Support**: Modern Swift concurrency built-in
- **🔄 Request Lifecycle Hooks**: Intercept and modify requests/responses at any stage
- **🎛 Concurrency Control**: Built-in task queue for managing concurrent requests
- **🛡 Type-Safe**: Leverage Swift's type system for safer networking code
- **📦 Alamofire-Powered**: Built on the reliable Alamofire foundation

## Installation

### Swift Package Manager

Add ServiceKit to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ServiceKit.git", from: "1.1.0")
]
```

## Quick Start

### 1. Define Your API Endpoint

```swift
import ServiceKit

enum UserAPI {
    case login(email: String, password: String)
    case getProfile(userId: String)
}

extension UserAPI: Target {
    var URL: URLPath {
        switch self {
        case .login:
            return .init(baseURL: "https://api.example.com", path: "/auth/login")
        case .getProfile(let userId):
            return .init(baseURL: "https://api.example.com", path: "/users/\(userId)")
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .getProfile: return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .getProfile:
            return nil
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var plugins: [Plugin] {
        return [AuthPlugin(), LoggingPlugin()]
    }
}
```

### 2. Create a Plugin (Middleware)

Plugins allow you to inject custom behavior at different stages of the request lifecycle:

```swift
struct AuthPlugin: Plugin {
    func prepare(_ request: URLRequest, target: Target) -> URLRequest {
        var request = request
        // Add authentication token before sending
        if let token = TokenManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func didReceive<T: Decodable>(
        response: GenericResponse<T>,
        target: Target
    ) async throws -> GenericResponse<T> {
        // Handle authentication errors
        if response.statusCode == 401 {
            // Refresh token or redirect to login
            throw ServiceError.unauthorized
        }
        return response
    }
}
```

### 3. Make Network Calls

```swift
let provider = GeneralProvider()

// Async/await style
do {
    let response: GenericResponse<User> = try await provider.request(UserAPI.getProfile(userId: "123").toEndPoint())
    print("User: \(response.data)")
} catch {
    print("Error: \(error)")
}
```

## Architecture

### Core Components

#### `Target`
Protocol that defines an API endpoint with all necessary information:
- URL (base + path)
- HTTP method
- Parameters
- Headers
- Associated plugins

#### `Plugin`
Protocol for creating middleware that can:
- **`prepare(_:target:)`**: Modify requests before sending (e.g., add auth tokens)
- **`willSend(_:target:)`**: Observe requests being sent (e.g., logging)
- **`didReceive(response:target:)`**: Transform or validate responses (e.g., error mapping)

#### `GeneralProvider`
Executes network requests using Alamofire with async/await support.

#### `TaskQueue`
Actor-based concurrency manager for controlling request execution flow.

## Common Use Cases

### Authentication Plugin

```swift
struct AuthPlugin: Plugin {
    func prepare(_ request: URLRequest, target: Target) -> URLRequest {
        var request = request
        request.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")
        return request
    }
}
```

### Logging Plugin

```swift
struct LoggingPlugin: Plugin {
    func willSend(_ request: URLRequest, target: Target) {
        print("📤 Sending: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
    }
    
    func didReceive<T: Decodable>(
        response: GenericResponse<T>,
        target: Target
    ) async throws -> GenericResponse<T> {
        print("📥 Received: \(response.statusCode)")
        return response
    }
}
```

### Error Mapping Plugin

```swift
struct ErrorMappingPlugin: Plugin {
    func didReceive<T: Decodable>(
        response: GenericResponse<T>,
        target: Target
    ) async throws -> GenericResponse<T> {
        switch response.statusCode {
        case 400: throw AppError.badRequest
        case 401: throw AppError.unauthorized
        case 404: throw AppError.notFound
        case 500: throw AppError.serverError
        default: return response
        }
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---
