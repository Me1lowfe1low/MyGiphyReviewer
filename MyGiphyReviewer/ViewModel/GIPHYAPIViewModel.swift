// Created for MyGiphyReviewer on 20.04.2023
//  GIPHYAPIViewModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation
import Photos

class GIPHYAPIViewModel: ObservableObject {
    private let cache: NSCache<NSString, NSData>
    private var apiKey = "91NSZN24dZULJSHQkAsOWynsEcR1xQBw"
    
    private let limit: Int
    var page: Int
    var maxIndex: Int
    
    @Published var loadingState: LoadingState

    init(cache: NSCache<NSString, NSData> = .init()) {
        self.cache = cache
        self.cache.countLimit = 50
        self.page = 0
        self.limit = 40
        
        self.maxIndex = 0
        
        self.loadingState = .good
    }
    
    func buildURLRequest(for searchObject: String) -> URL {
        let offset = page * limit
        guard let url = URL(string:"https://api.giphy.com/v1/gifs/search?api_key=\(apiKey)&q=\(searchObject)&limit=\(self.limit)&offset=\(offset)&rating=g&lang=en") else {
                    return URL(string: "https://api.giphy.com/v1/gifs/search?api_key=91NSZN24dZULJSHQkAsOWynsEcR1xQBw&q=memes&limit=25&offset=0&rating=g&lang=en")!
                }
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
    
    func fetchOneSampleOfData(item: GifGridItem) async -> Data {
        if let cached = cache.object(forKey: item.gifID as NSString) { return cached as Data }
        
        do {
            guard let url = URL(string: item.gifURL) else { return Data() }
            let response = try await URLSession.shared.data(from: url)
            let data = response.0
            cache.setObject(data as NSData, forKey: item.gifID as NSString)
            print("cached item ( index: \(item.index), page: \(self.page) gifId: \(item.gifID)")
            return data
        } catch let error {
            print(error.localizedDescription)
            return Data()
        }
    }
    
    func fetchGifs(url: URL) async -> [GifGridItem] {
        guard loadingState == .good else {
            return []
        }
        do {
            self.loadingState = .isLoading
            let response = try await URLSession.shared.data(from: url)
            let decodedGiphy = try JSONDecoder().decode(GifDataStructure.self, from: response.0)
            
            var gridItems: [GifGridItem] = []
            decodedGiphy.data.forEach { gifData in
                let randomHeight = CGFloat.random(in: 100 ... 400)
                let gifURL: String = self.buildGIFURLString(for: gifData.id)
                gridItems.append(GifGridItem(index: self.maxIndex, height: randomHeight, gifURL: gifURL, gifGIPHYURL: gifData.url, gifID: gifData.id))
                print(self.maxIndex)
                self.maxIndex += 1
            }
            print("Gathered grid for page#: \(self.page)")
            return gridItems
        } catch let error {
            self.loadingState = .error("Error in loading gifs: \(error.localizedDescription)")
            return []
        }
    }
    
    func downloadGIFFile(_ item: GifGridItem) async  {
        var gifData = Data()
        print("Checking in cache gifID: \(item.gifID)")
        do {
            if let cached = cache.object(forKey: item.gifID as NSString) {
                print("Using cached data")
                gifData = cached as Data
            } else {
                print("Using fresh data")
                guard let url = URL(string: item.gifURL) else { return }
                let response = try await URLSession.shared.data(from: url)
                gifData = response.0
                cache.setObject(gifData as NSData, forKey: item.gifID as NSString)
            }
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
