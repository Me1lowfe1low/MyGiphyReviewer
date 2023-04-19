// Created for MyGiphyReviewer on 19.04.2023
//  SingleGifView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct SingleGifView: View {
    @State var gridItem: GifGridItem
    
    var body: some View {
        ZStack {
            GeometryReader { geoProxy in
                Image(systemName: gridItem.gifURL)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
            }
        }
        .frame(height: gridItem.height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }
}

struct SingleGifView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGifView(gridItem: GifGridItem(height: 200.0, gifURL: "rectangle.portrait"))
    }
}
