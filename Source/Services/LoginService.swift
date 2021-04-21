//
//  LoginServiceProtocol.swift
//  NetworkCaller-Kickstarter (iOS)
//
//  Created by ebpearls on 4/21/21.
//

import Combine
import Foundation

protocol LoginServiceProtocol {
    func loginUser(username: String, password: String) -> AnyPublisher<Data, Error>
}


class LoginService: LoginServiceProtocol {
    private let apiProvider = APIProvider<AppEndpoint>()
        
    init() {}
    
    func loginUser(username: String, password: String) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(
            from: .login(email: username, password: password)
        )
        .eraseToAnyPublisher()
    }
}
