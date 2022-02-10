//
//  AuthManager.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 03/02/2022.
//

import Foundation
import Combine

class AuthManager {
    
    static let shared = AuthManager()
    
    private let authKey: String = {
        let rawKey = "YOUR_CLIENT_ID:YOUR_CLIENT_SECRET"
        let encodedKey = rawKey.data(using: .utf8)?.base64EncodedString() ?? ""
        return "Basic \(encodedKey)"
    }()
    
    private init() {}
    
    /// Request method for authentication token.
    func getAccessToken() -> AnyPublisher<String, Error> {
        guard let url = NetworkURL.tokenURL else {
            return Fail(error: NSError(domain: "Missing API URL", code: -10001, userInfo: nil)).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        let requestHeaders: [String: String] = ["Authorization": authKey,
                                                "Content-Type": "application/x-www-form-urlencoded"]
        var requestBody = URLComponents()
        requestBody.queryItems = [URLQueryItem(name: "grant_type", value: "client_credentials")]
        urlRequest.allHTTPHeaderFields = requestHeaders
        urlRequest.httpBody = requestBody.query?.data(using: .utf8)
        urlRequest.httpMethod = HTTPMethods.post.rawValue
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            })
            .decode(type: AccessToken.self, decoder: JSONDecoder())
            .map({ accessToken -> String in
                guard let token = accessToken.token else {
                    print("The access token is not fetched.")
                    return ""
                }
                return token
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
