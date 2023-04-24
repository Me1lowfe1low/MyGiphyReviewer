// Created for MyGiphyReviewer on 19.04.2023
//  MosaicGridView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

/// MosaicGridView - view that shows elements in mosaic layout.
///  As input it requests - structure with gifs
struct MosaicGridView: View {
    @EnvironmentObject var gifAPI: GIPHYAPIService
    @ObservedObject var gifs: GifViewModel
    
    init(gifs: ObservedObject<GifViewModel>) {
        self._gifs = gifs
    }
    
    var body: some View {
        HStack(alignment: . top, spacing: 10) {
            ForEach(gifs.columns, id: \.self) { column in
                LazyVStack(spacing: 10) {
                    ForEach(column.gridItems, id: \.self) { gridItem in
                        SingleGifView(gifs: gifs, gridItem: gridItem)
                            .environmentObject(gifAPI)
                    }
                }
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

