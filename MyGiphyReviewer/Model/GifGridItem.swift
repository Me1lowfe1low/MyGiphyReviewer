// Created for MyGiphyReviewer on 19.04.2023
//  GifGridItem.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

struct GifGridItem: Identifiable, Hashable {
    let id: UUID = UUID()
    let index: Int
    let height: CGFloat
    let gifURL: String
    let gifGIPHYURL: String
    let gifID: String
    var gifData: Data? = nil
    
    mutating func setData(_ data: Data) {
        self.gifData = data
    }
    
#if DEBUG
    static let dataSample: GifGridItem = GifGridItem(index: 0, height: 200.0, gifURL: "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDQyZjczZDAwYjkzZDQ1MjhkNmNhZDkyYzVhMTcxNzVlY2UxMzQwNSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/0v0KlsuyXUvTrLPXZu/giphy.gif", gifGIPHYURL: "https://giphy.com/gifs/giatec-dogs-construction-3ov9jRPMChw9ZzVlUk" ,gifID: "0v0KlsuyXUvTrLXZu")
#endif
}

struct GifDataStructure: Decodable {
    let data: [dataStructure]
}

struct dataStructure: Decodable {
    let id: String
    let url: String
}
