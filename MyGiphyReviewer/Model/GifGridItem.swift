// Created for MyGiphyReviewer on 19.04.2023
//  GifGridItem.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

struct GifGridItem: Identifiable {
    let id: UUID = UUID()
    let height: CGFloat
    let gifURL: String
    let gifID: String
    var gifData: Data? = nil
    
    mutating func setData(_ data: Data) {
        self.gifData = data
    }
}
