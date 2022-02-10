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
            let albumImageList = viewModel.getAlbumImageList()
            List(Array(zip(albumList, albumImageList)), id: \.0) { album, albumImage in
                HStack {
                    Image(uiImage: albumImage)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(150/2)
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
                viewModel.fetchAlbumList()
            }.navigationBarTitle("Cem Kazim's Albums")
        }
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView(viewModel: AlbumListViewModel())
    }
}
