// Created for MyGiphyReviewer on 19.04.2023
//  SingleGifView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct SingleGifView: View {
    @EnvironmentObject var gifAPI: GIPHYAPIService
    @ObservedObject var gifs: GifViewModel
    @State var gridItem: GifGridItem
    
    
    var body: some View {
        ZStack {
            GeometryReader { geoProxy in
                if let data = gridItem.gifData, !gridItem.gifData!.isEmpty {
                    NavigationLink(destination: ExportShareView(gifs: gifs, gridItem: gridItem)) {
                        GIFImage(data: data)
                            .scaledToFit()
                            .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
                    }
                }
                else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(colors: ColorOptions.allCases.randomElement()!.colorMap, startPoint: .bottomLeading, endPoint: .topTrailing))
                        .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
                }
             }
             .task {
                 let data = await gifAPI.fetchOneSampleOfData(gridItem)
                 await MainActor.run {
                     gridItem.gifData = data
                }
            }
        }
        .frame(height: gridItem.height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }
}

struct SingleGifView_Previews: PreviewProvider {
    static var previews: some View {
        let gifAPI = GIPHYAPIService()
        SingleGifView(gridItem: GifGridItem.dataSample, gifs: GifViewModel())
            .environmentObject(gifAPI)
    }
}

