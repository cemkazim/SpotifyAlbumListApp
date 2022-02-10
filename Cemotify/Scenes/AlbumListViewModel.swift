//
//  AlbumListViewModel.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 02/02/2022.
//

import UIKit
import Combine

class AlbumListViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var albumList: Array<Item> = []
    @Published private var albumImageList: Array<UIImage> = []
    
    init() {
        DataProvider.shared.getArtistsAlbums(id: "577aiGHd8W7Q8YPKIQEr4O")
    }
    
    func fetchAlbumList() {
        DataProvider.shared.artistAlbumsSubject
            .sink(receiveValue: { [weak self] items in
                guard let self = self else { return }
                self.albumList = items
                self.setAlbumImageList(with: items)
            }).store(in: &cancellables)
    }
    
    func getAlbumList() -> Array<Item> {
        return albumList
    }
    
    private func setAlbumImageList(with albums: [Item]) {
        for album in albums {
            if let firstImage = album.images?.first,
               let imageURL = URL(string: firstImage.url ?? ""),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                albumImageList.append(image)
            }
        }
    }
    
    func getAlbumImageList() -> Array<UIImage> {
        return albumImageList
    }
}
