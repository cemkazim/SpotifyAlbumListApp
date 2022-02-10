//
//  AlbumListView.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 01/02/2022.
//

import SwiftUI

struct AlbumListView: View {
    
    @ObservedObject var viewModel: AlbumListViewModel
    
    var body: some View {
        NavigationView {
            let albumList = viewModel.getAlbumList()
            let albumImageUrls = viewModel.getAlbumImageUrls()
            List(Array(zip(albumList, albumImageUrls)), id: \.0) { album, albumImageUrl in
                HStack {
                    if let imageData = try? Data(contentsOf: albumImageUrl),
                       let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .cornerRadius(150/2)
                            .frame(width: 150, height: 150)
                            .clipped()
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        if let name = album.name,
                           let albumType = album.albumType,
                           let releaseDate = album.releaseDate,
                           let spotifyUrl = album.externalUrls?.spotify,
                           let totalTracks = album.totalTracks {
                            Text("Name: \(name)").font(.headline)
                            Text("Release Date: \(releaseDate)").font(.subheadline)
                            Text("Total Tracks: \(totalTracks)").font(.subheadline)
                            Link("go to \(albumType)", destination: URL(string: spotifyUrl)!)
                        }
                    }.padding(.leading, 8)
                }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
            }.onAppear {
                viewModel.getData()
            }.navigationBarTitle("Cem Kazim's Albums")
        }
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView(viewModel: AlbumListViewModel())
    }
}
