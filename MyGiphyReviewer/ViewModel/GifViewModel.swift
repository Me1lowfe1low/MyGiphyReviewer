// Created for MyGiphyReviewer on 19.04.2023
//  GifViewModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

@MainActor
class GifViewModel: ObservableObject {
    @Published var gridItems = [GifGridItem]()
    private let giphyAPI: GIPHYAPIViewModel
    private let queryString: String
    
    init(queryString: String = "dogs", giphyAPI: GIPHYAPIViewModel = GIPHYAPIViewModel()) {
        self.queryString = queryString
        self.giphyAPI = giphyAPI
    }
    
    func fetchRecords() {
        let url = giphyAPI.buildURLRequest(for: queryString)
        Task {
            let gridItems = await giphyAPI.fetchGifs(url: url)
            await MainActor.run { [weak self] in
                self?.gridItems.append(contentsOf: gridItems)
                //self?.gridItems = gridItems
            }
        }
    }
}
