// Created for MyGiphyReviewer on 19.04.2023
//  GifViewModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation
import Photos

@MainActor
class GifViewModel: ObservableObject {
    @Published var gridItems = [GifGridItem]()
    @Published var loadingState: LoadingState
    private let giphyAPI: GIPHYAPIService
    
    private let searchObject: String
    
    private let limit: Int
    var page: Int
    var maxIndex: Int
    
    init(queryString: String = "dogs", giphyAPI: GIPHYAPIService = GIPHYAPIService()) {
        self.searchObject = queryString
        self.giphyAPI = giphyAPI
        
        self.page = 0
        self.limit = 10
        
        self.maxIndex = 0
        
        self.loadingState = .readyForFetch
    }
}

extension GifViewModel {
    
    func fetchRecords() {
        let url = buildURLRequest(for: searchObject)
        Task {
            self.loadingState = .isLoading
            let fetchedData = await giphyAPI.fetchGifs(url: url)
            await MainActor.run { [weak self] in
                fetchedData.data.forEach { gifData in
                    let randomHeight = CGFloat.random(in: 100 ... 400)
                    let gifURL: String = (self?.buildGIFURLString(for: gifData.id))!
                    self?.gridItems.append(GifGridItem(index: self?.maxIndex ?? 0, height: randomHeight, gifURL: gifURL, gifGIPHYURL: gifData.url, gifID: gifData.id))
                    print(self?.maxIndex)
                    self?.maxIndex += 1
                }
                //self?.gridItems = gridItems
                self?.page += 1
                print("Gathered grid for page#: \(self?.page)")
                self?.loadingState = .readyForFetch
            }
        }
    }
}

extension GifViewModel {
    func buildURLRequest(for searchObject: String) -> URL {
        let offset: Int = self.page * self.limit
        let urlData: URLDataModel = URLDataModel(searchObject: self.searchObject, limit: self.limit, offset: offset, rating: "g", lang: "en")
        let url = giphyAPI.prepareURL(for: urlData)
        return url
    }

    private func buildGIFURLString(for gifID: String) -> String {
        "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDQyZjczZDAwYjkzZDQ1MjhkNmNhZDkyYzVhMTcxNzVlY2UxMzQwNSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/" + gifID + "/giphy.gif"
    }
    
    private func buildGIFSystemURL() -> String {
        let currentTime = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmssSSS"
        let fileTimeSuffix = formatter.string(from: currentTime)
        return "GIPHY_" + fileTimeSuffix + ".gif"
    }
}

extension GifViewModel {

    func saveGifFile(_ item: GifGridItem) async {
        do {
            let gifData = await giphyAPI.downloadGIFFile(item)
            print(gifData)
            print("File gathered")
            try await PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                let fileName = PHAssetResourceCreationOptions()
                fileName.originalFilename = self.buildGIFSystemURL()
                creationRequest.addResource(with: .photo, data: gifData, options: fileName)
                print("Filename: \(String(describing: fileName.originalFilename))")
            })
            print("File saved")
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
