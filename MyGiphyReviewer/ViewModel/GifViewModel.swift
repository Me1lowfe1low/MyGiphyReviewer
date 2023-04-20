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
    private var giphyAPI: GIPHYAPIViewModel = GIPHYAPIViewModel()
    
    
    init() {
        let url = giphyAPI.buildURLRequest(for: "memes")
        giphyAPI.fetchMultipleRecords(urlString: url) { gridItems, error in
            if var gridItems = gridItems {
                self.gridItems.append(gridItems)

            }
            else {
                self.gridItems = []
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    

}

struct GifDataStructure: Decodable {
    let data: [dataStructure]
}

struct dataStructure: Decodable {
    let id: String
    let url: String
}

