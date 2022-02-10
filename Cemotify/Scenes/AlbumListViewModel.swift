//
//  AlbumListViewModel.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 02/02/2022.
//

import Foundation
import Combine

class AlbumListViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var albumList: Array<Item> = []
    @Published private var albumImageUrls: Array<URL> = []
    
    init() {
        DataProvider.shared.getArtistsAlbums(id: "577aiGHd8W7Q8YPKIQEr4O")
    }
    
    func getData() {
        DataProvider.shared.artistAlbumsSubject
            .sink(receiveValue: { [weak self] items in
                guard let self = self else { return }
                self.albumList = items
                self.setAlbumImageUrls(with: items)
            }).store(in: &cancellables)
    }
    
    func getAlbumList() -> Array<Item> {
        return albumList
    }
    
    private func setAlbumImageUrls(with albums: [Item]) {
        for album in albums {
            if let firstImageUrl = album.images?.first?.url,
               let imageUrl = URL(string: firstImageUrl) {
                albumImageUrls.append(imageUrl)
            }
        }
    }
    
    func getAlbumImageUrls() -> Array<URL> {
        return albumImageUrls
    }
}
