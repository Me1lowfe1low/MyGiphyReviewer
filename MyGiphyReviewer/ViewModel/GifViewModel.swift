// Created for MyGiphyReviewer on 19.04.2023
//  GifViewModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

class GifViewModel: ObservableObject {
    @Published var gridItems = [GifGridItem]()
    
    init(limits: Int ) {
        for _ in 0 ..< limits {
            let randomHeight = CGFloat.random(in: 100 ... 400)
            self.gridItems.append(GifGridItem(height: randomHeight, gifURL: String("rectangle.portrait")))
        }
    }
}
