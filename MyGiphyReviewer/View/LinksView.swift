// Created for MyGiphyReviewer on 21.04.2023
//  LinksView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct LinksView: View {
    @State var link: String
    @State private var urlString: URL
    
    init(link: String) {
        self._link = State(initialValue: link)
        self._urlString = State(initialValue: URL(string: link)! )
    }
    
    var body: some View {
        HStack {
            ShareLink(item: link) {
                Text("Share GIF")
                    .modifier(ButtonViewModifier(font: .title2, backgroundColor: .blue))
            }
        }
    }
}

struct LinksView_Previews: PreviewProvider {
    static var previews: some View {
        LinksView(link: GifGridItem.dataSample.gifURL)
    }
}
