//
//  AccessToken.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 03/02/2022.
//

import Foundation

struct AccessToken: Decodable {
    let token: String?
    let type: String?
    let expire: Int?
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case type = "token_type"
        case expire = "expires_in"
    }
}
