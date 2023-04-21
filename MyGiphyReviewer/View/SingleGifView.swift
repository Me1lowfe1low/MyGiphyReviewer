// Created for MyGiphyReviewer on 19.04.2023
//  SingleGifView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct SingleGifView: View {
    @State var gridItem: GifGridItem
    //@StateObject var gifAPI: GIPHYAPIViewModel = GIPHYAPIViewModel()
    @State var sheetIsOpened = false
    @EnvironmentObject var gifAPI: GIPHYAPIViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geoProxy in
                if let data = gridItem.gifData, !gridItem.gifData!.isEmpty {
                    Button(action: { sheetIsOpened.toggle() })
                    {
                        GIFImage(data: data)
                            .scaledToFill()
                            .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
                    }
                    .sheet(isPresented: $sheetIsOpened) {
                        ExportShareView(gridItem: gridItem, state: $sheetIsOpened)
                    }
                }
                else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(colors: ColorOptions.allCases.randomElement()!.colorMap, startPoint: .bottomLeading, endPoint: .topTrailing))
                        .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
                }
             }
             .task {
                 let data = await gifAPI.fetchOneSampleOfData(item: gridItem)
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
        let gifAPI = GIPHYAPIViewModel()
        SingleGifView(gridItem: GifGridItem.dataSample)
            .environmentObject(gifAPI)
    }
}

