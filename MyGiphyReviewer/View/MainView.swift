// Created for MyGiphyReviewer on 19.04.2023
//  MainView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct MainView: View {
    @State var gifData : [String] = []
    @State var present = false
    @State var url = ""
    @State var gifs: GifViewModel = GifViewModel(limits: 25)
    
    var body: some View {
        ScrollView {
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
