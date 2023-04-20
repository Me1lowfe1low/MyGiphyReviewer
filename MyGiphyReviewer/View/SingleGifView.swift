// Created for MyGiphyReviewer on 19.04.2023
//  SingleGifView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI
import Kingfisher


struct SingleGifView: View {
    @State var gridItem: GifGridItem
    @StateObject var gifAPI: GIPHYAPIViewModel = GIPHYAPIViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geoProxy in
                if let data = gridItem.gifData {
                    //GIFImage(data: data)
                    KFAnimatedImage(URL(string: gridItem.gifURL))
                        .scaledToFill()
                    
                        .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
                }
                else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(colors: ColorOptions.allCases.randomElement()!.colorMap, startPoint: .bottomLeading, endPoint: .topTrailing))
                        .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
                        .onAppear(perform: {
                            gifAPI.fetchOneSampleOfData(urlString: gridItem.gifURL) { data, error in
                                if let data = data {
                                    DispatchQueue.main.async {
                                        gridItem.gifData = data
                                    }
                                } else {
                                    print(error?.localizedDescription)
                                }
                            }
                        })
                }
            }
        }
        .frame(height: gridItem.height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }
    
    func updateGifData() {
        //print("updating imgage")
        

    }
}

struct SingleGifView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGifView(gridItem: GifGridItem(height: 200.0, gifURL: "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDQyZjczZDAwYjkzZDQ1MjhkNmNhZDkyYzVhMTcxNzVlY2UxMzQwNSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/0v0KlsuyXUvTrLPXZu/giphy.gif", gifID: "0v0KlsuyXUvTrLXZu"))
    }
}

