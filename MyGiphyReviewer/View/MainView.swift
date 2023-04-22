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
        VStack {
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
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    MosaicGridView(gridItems: gifs.gridItems)
                        .padding()
                    switch gifAPI.loadingState {
                        case .readyForFetch:
                            ZStack{
                                Spacer()
                                Color.red
                                    .frame(height: 300)
                                    .task {
                                        Task {
                                            print("state: \(gifAPI.loadingState)")
                                            print("Loading more data")
                                            gifs.fetchRecords()
                                        }
                                    }
                            }
                        case .isLoading:
                            ProgressView()
                                .progressViewStyle(.circular)
                        case .initialState:
                            Color.yellow
                        case .error(let error):
                            Text(error)
                                .font(.title)
                    }
                }
//                .task {
//                    gifs.fetchRecords()
//                }
            }
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
