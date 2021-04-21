//
//  APIProvider.swift
//  NetworkCaller-Kickstarter (iOS)
//
//  Created by ebpearls on 4/21/21.
//

import Foundation
import Combine

class APIProvider<Endpoint: EndpointProtocol> {
    func getData(from endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        guard let request = performRequest(for: endpoint) else {
            return Fail(error: APIProviderErrors.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return loadData(with: request)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Request building
    private func performRequest(for endpoint: Endpoint) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.absoluteURL) else {
            return nil
        }
        
        var bodyData: Data?
        switch endpoint.encoding {
        case .url:
            urlComponents.queryItems = endpoint.params.compactMap({ param -> URLQueryItem in
                return URLQueryItem(name: param.key, value: param.value)
            })
        case .json:
            bodyData = try? JSONSerialization.data(withJSONObject: endpoint.params, options: .prettyPrinted)
        }

        guard let url = urlComponents.url else {
            return nil
        }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadRevalidatingCacheData,
                                    timeoutInterval: 30)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = bodyData
        
        
        endpoint.headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return urlRequest
    }
    
    // MARK: - Getting data
    private func loadData(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ error -> Error in
                APIErrors(rawValue: error.code.rawValue) ?? APIProviderErrors.unknownError
            })
            .map {
                debugPrint("JSON String:: ", $0.data.prettyPrintedJSONString as Any)
                return $0.data
            }
            .eraseToAnyPublisher()
    }
}
