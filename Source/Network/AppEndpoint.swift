//
//  Network.swift
//  NetworkCaller-Kickstarter (iOS)
//
//  Created by ebpearls on 4/21/21.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case delete
    case update
    case put
}

public enum ParameterEncoding {
    case json
    case url
}

protocol EndpointProtocol {
    var locale: String { get }
    
    var region: String { get }
    
    var baseURL: String { get }
    
    var absoluteURL: String { get }
        
    var params: [String: String] { get }
    
    var headers: [String: String] { get }
    
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
}

extension EndpointProtocol {
    var locale: String {
        return Locale.current.languageCode ?? "en"
    }
    
    var region: String {
        return Locale.current.regionCode ?? "us"
    }
}


enum AppEndpoint: EndpointProtocol {
    case login(email: String, password: String)
    case singup(email: String, password: String)
    
    var baseURL: String {
        return "https://test-nirvana/"
    }
    
    var absoluteURL: String {
        switch self {
        case .login:
            return baseURL + "api/v1/user/signin"
        case .singup:
            return baseURL + "api/v1/user/signup"
        }
    }
    
    var params: [String: String] {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .singup(let email, let password):
            return ["email": email, "password": password]
        }
    }
    
    var headers: [String: String] {
        return [
            "Content-type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .singup: return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login, .singup: return .json
        }
    }
}
