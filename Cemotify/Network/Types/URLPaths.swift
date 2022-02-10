//
//  URLTypes.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 02/02/2022.
//

import Foundation

enum URLPaths {
    
    case path
    case content
}

extension URLPaths {
    
    var getArtistsAlbumsTypes: String {
        switch self {
        case .path:
            return "/artists"
        case .content:
            return "/albums"
        }
    }
}
