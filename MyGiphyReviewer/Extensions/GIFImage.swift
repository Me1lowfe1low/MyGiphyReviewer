// Created for MyGiphyReviewer on 19.04.2023
//  GIFImage.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct GIFImage: UIViewRepresentable {
    private let data: Data?
    
    init(data: Data) {
        self.data = data
    }
    
    func makeUIView(context: Context) -> UIGIFImage {
        if let data = data {
            return UIGIFImage(data: data)
        } else {
            return UIGIFImage()
        }
    }
    
    func updateUIView(_ uiView: UIGIFImage, context: Context) {
        if let data = data {
            uiView.updateGIF(data: data)
        } else {
            print("No data")
        }
    }
}
