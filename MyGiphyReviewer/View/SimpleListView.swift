// Created for MyGiphyReviewer on 19.04.2023
//  SimpleListView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

///  As input it requests - structure with gifs
struct SimpleListView: View {
    @EnvironmentObject var gifAPI: GIPHYAPIService
    @ObservedObject var gifs: GifViewModel
    
    init(gifs: ObservedObject<GifViewModel>) {
        self._gifs = gifs
    }
    var body: some View {
        LazyVStack(spacing: 10) {
            ForEach(gifs.gridItems, id: \.self) { gridItem in
                SingleGifView(gifs: gifs, gridItem: gridItem)
                    .environmentObject(gifAPI)
            }
        }
    }
}

struct MosaicGridView_MainView_Previews: PreviewProvider {
    static var previews: some View {
        let gifAPI = GIPHYAPIService()
        MainView()
            .environmentObject(gifAPI)
    }
}

