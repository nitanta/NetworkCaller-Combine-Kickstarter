//
//  APIErrors.swift
//  NetworkCaller-Kickstarter (iOS)
//
//  Created by ebpearls on 4/21/21.
//

import Foundation

enum APIErrors: Int, LocalizedError {
    case badRequest = 400
    case unAuthorized = 401
    case tooManyRequests = 429
    case serverError = 500
    
    var errorDescription: String? {
        switch self {
        case .tooManyRequests:
            return "You made too many requests within a window of time and have been rate limited. Back off for a while."
        case .serverError:
            return "Server error."
        default:
            return "Something went wrong."
        }
    }
}

enum APIProviderErrors: LocalizedError {
    case invalidURL
    case dataNil
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .dataNil:
            return "Empty data."
        case .decodingError:
            return "Data has invalid format."
        default:
            return "Something goes wrong."
        }
    }
}

