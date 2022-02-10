//
//  APIURL.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 02/02/2022.
//

import Foundation

enum NetworkURL {
    
    case getArtistsAlbums(artistID: String)
}

extension NetworkURL {

    var url: URL? {
        switch self {
        case .getArtistsAlbums(let artistID):
            let baseURL = NetworkURL.baseURL?.absoluteString ?? ""
            return URL(string: baseURL + URLPaths.path.getArtistsAlbumsTypes + "/\(artistID)" + URLPaths.content.getArtistsAlbumsTypes)
        }
    }
    
    static var baseURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1"
        guard let url = components.url else { return nil }
        return url
    }
    
    static var tokenURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.spotify.com"
        components.path = "/api/token"
        guard let url = components.url else { return nil }
        return url
    }
    
    static var authKey: String {
        let rawKey = "YOUR_CLIENT_ID:YOUR_CLIENT_SECRET_KEY"
        let encodedKey = rawKey.data(using: .utf8)?.base64EncodedString() ?? ""
        return "Basic " + encodedKey
    }
}
