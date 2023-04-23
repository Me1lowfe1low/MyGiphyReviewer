// Created for MyGiphyReviewer on 20.04.2023
//  ExportShareView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI
import Photos


struct ExportShareView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var gifs: GifViewModel
    @State var gridItem: GifGridItem
    private let pastboard = UIPasteboard.general
    @State var imagePath: String = ""
    
    
    var body: some View {
        VStack {
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: dismissSheet ) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: saveGIFToPhotos ) {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    func dismissSheet() {
        dismiss()
    }
    
    func copyGIFLink() {
        self.pastboard.string = gridItem.gifURL
    }
    
    func copyGIFGIPHYLink() {
        self.pastboard.string = gridItem.gifGIPHYURL
    }
    
    func saveGIFToPhotos() {
        Task {
            await gifs.saveGifFile(gridItem)
        }
    }
}

struct ExportShareView_Previews: PreviewProvider {
    static var previews: some View {
        ExportShareView(gifs: GifViewModel(), gridItem: GifGridItem.dataSample)
    }
}
