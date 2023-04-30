// Created for MyGiphyReviewer on 19.04.2023
//  MainView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct MainView: View {
    @ObservedObject var gifs: GifViewModel = GifViewModel()
    @EnvironmentObject var gifAPI: GIPHYAPIService

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(ApiEndpointOption.allCases, id: \.self) { tabElement in
                        Button( action: {
                            if gifs.endpoint != tabElement {
                                gifs.changeTab(endpoint: tabElement)
                            }
                        }) {
                            Text(tabElement.title)
                                .padding()
                                .background(.purple.opacity(tabElement == gifs.endpoint ? 1.0 : 0.0))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    SimpleListView(gifs: _gifs)
                        .environmentObject(gifAPI)
                        .padding()
                    switch gifs.loadingState {
                        case .readyForFetch:
                            Color.clear
                            .task {
                                Task {
                                    print("state: \(gifs.loadingState)")
                                    gifs.fetchRecords()
                                }
                            }
                        case .isLoading:
                            ProgressView()
                                .progressViewStyle(.circular)
                                   
                        case .initialState:
                            Color.clear
                                .task {
                                    Task {
                                        print("state: \(gifs.loadingState)")
                                        gifs.fetchRecords()
                                    }
                                }
                        case .allIsLoaded:
                            EmptyView()
                        case .error(let error):
                            Text(error)
                                .font(.title)
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let gifAPI = GIPHYAPIService()
        MainView()
            .environmentObject(gifAPI)
    }
}
