//
//  CemotifyApp.swift
//  Cemotify
//
//  Created by Cem Kazım Genel on 01/02/2022.
//

import SwiftUI
import Combine

@main
struct CemotifyApp: App {
    
    var body: some Scene {
        WindowGroup {
            AlbumListView(viewModel: AlbumListViewModel())
        }
    }
}
