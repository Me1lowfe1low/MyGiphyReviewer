// Created for MyGiphyReviewer on 20.04.2023
//  ExportShareView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI
import Photos


struct ExportShareView: View {
    @State var gridItem: GifGridItem
    @Binding var state: Bool
    private let pastboard = UIPasteboard.general
    @ObservedObject var gifAPI: GIPHYAPIViewModel = GIPHYAPIViewModel()
    @State var imagePath: String = ""
    
    var body: some View {
        VStack {
            HStack{
                Button(action: dismissSheet ) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
                Spacer()
                //Text(imagePath)
                Spacer()
                Button(action: saveGIFToPhotos ) {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(.plain)
            }
            .padding()
            if let data = gridItem.gifData {
                GIFImage(data: data)
                    .scaledToFit()
            }
            Spacer()
            Group {
                Button(action: copyGIFLink) {
                    Text("Copy GIF Link")
                        .modifier(ButtonViewModifier(font: .title2, backgroundColor: .blue))
                }
                Button(action: copyGIFGIPHYLink ) {
                    Text("Copy GIF")
                        .modifier(ButtonViewModifier(font: .title2, backgroundColor: .gray))
                }
                Button(action: dismissSheet ) {
                    Text("Cancel")
                        .modifier(ButtonViewModifier(font: .title3, backgroundColor: .black))
                }
                Spacer()
            }
        }
    }
    
    func dismissSheet() {
        self.state.toggle()
    }
    
    func copyGIFLink() {
        self.pastboard.string = gridItem.gifURL
    }
    
    func copyGIFGIPHYLink() {
        self.pastboard.string = gridItem.gifGIPHYURL
    }
    
    func saveGIFToPhotos() {
        Task {
            await gifAPI.downloadGIFFileFromLink(gridItem.gifURL)
        }
    }
}


struct ExportShareView_Previews: PreviewProvider {
    static var previews: some View {
        ExportShareView(gridItem: GifGridItem.dataSample, state: .constant(false))
    }
}
