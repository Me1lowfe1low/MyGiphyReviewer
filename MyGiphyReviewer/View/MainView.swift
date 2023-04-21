// Created for MyGiphyReviewer on 19.04.2023
//  MainView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct MainView: View {
    @ObservedObject var gifs: GifViewModel = GifViewModel()
    @EnvironmentObject var gifAPI: GIPHYAPIViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(TabBarModel.allCases, id: \.self) { tabElement in
                        Text(tabElement.title)
                            .padding()
                            .background(.yellow)
                            .clipShape(Capsule())
                    }
                }
            }
            MosaicGridView(gridItems: gifs.gridItems)
                .padding()
        }
        .task {
            gifs.fetchRecords()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let gifAPI = GIPHYAPIViewModel()
        MainView()
            .environmentObject(gifAPI)
    }
}
