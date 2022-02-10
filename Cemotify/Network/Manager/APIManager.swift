//
//  APIManager.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 02/02/2022.
//

import Foundation
import Combine

class APIManager<T: Decodable> {
    
    struct Model {
        let url: URL?
        let method: HTTPMethods
    }
    
    static var shared: APIManager<T> {
        return APIManager<T>()
    }
    
    private init() {}
    
    /// Request the API data with parameters (T is a decodable model).
    /// - Parameters:
    ///   - model: Data that can be helpful for the request model.
    func request(with model: Model) -> AnyPublisher<T, Error> {
        return AuthManager.shared.getAccessToken()
            .flatMap { tokenKey -> AnyPublisher<T, Error> in
                guard let url = model.url else {
                    return Fail(error: NSError(domain: "Missing API URL", code: -10001, userInfo: nil)).eraseToAnyPublisher()
                }
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = model.method.rawValue
                urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenKey)"]
                return URLSession.shared
                    .dataTaskPublisher(for: urlRequest)
                    .tryMap({ data, response in
                        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                            throw URLError(.badServerResponse)
                        }
                        return data
                    })
                    .decode(type: T.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
