// Created for MyGiphyReviewer on 19.04.2023
//  MainView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct MainView: View {
    @StateObject var gifs: GifViewModel = GifViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("MainViewInScroll")
            MosaicGridView(gridItems: gifs.gridItems)
                .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
