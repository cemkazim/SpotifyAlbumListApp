//
//  DataProvider.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 02/02/2022.
//

import Foundation
import Combine

class DataProvider {
    
    static let shared = DataProvider()
    
    private var cancellables = Set<AnyCancellable>()
    
    // Subscribers
    var artistAlbumsSubject = PassthroughSubject<[Item], Never>()
    
    private init() {}
}

// MARK: - Artist Albums Data Transactions

extension DataProvider {
    
    func getArtistsAlbums(id: String) {
        let url = NetworkURL.getArtistsAlbums(artistID: id).url
        let model = APIManager<ArtistAlbums>.Model(url: url, method: .get)
        APIManager.shared.request(with: model)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { albums in
            guard let items = albums.items else { return }
            self.artistAlbumsSubject.send(items)
        }).store(in: &self.cancellables)
    }
}
