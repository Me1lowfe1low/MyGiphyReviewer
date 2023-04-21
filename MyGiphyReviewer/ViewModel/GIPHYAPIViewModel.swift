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
    
    init(cache: NSCache<NSString, NSData> = .init()) {
             self.cache = cache
         }

    
    func buildURLRequest(for searchObject: String, limit: Int = 25, offset: Int = 0) -> URL {
             URL(string:"https://api.giphy.com/v1/gifs/search?api_key=\(apiKey)&q=\(searchObject)&limit=\(limit)&offset=\(offset)&rating=g&lang=en")!
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
    
    func fetchOneSampleOfData(urlString: String) async -> Data {
        if let cached = cache.object(forKey: urlString as NSString) { return cached as Data }
        
        do {
            guard let url = URL(string: urlString) else { return Data() }
            let response = try await URLSession.shared.data(from: url)
            let data = response.0
            cache.setObject(data as NSData, forKey: urlString as NSString)
            return data
        } catch let error {
            print(error.localizedDescription)
            return Data()
        }
    }
    
    func fetchMultipleRecords(url: URL) async -> [GifGridItem] {
        do {
            let response = try await URLSession.shared.data(from: url)
            let decodedGiphy = try JSONDecoder().decode(GifDataStructure.self, from: response.0)
            
            var gridItems: [GifGridItem] = []
            decodedGiphy.data.forEach { gifData in
                let randomHeight = CGFloat.random(in: 100 ... 400)
                let gifURL: String = self.buildGIFURLString(for: gifData.id)
                gridItems.append(GifGridItem(height: randomHeight, gifURL: gifURL, gifGIPHYURL: gifData.url, gifID: gifData.id))
            }
            return gridItems
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func downloadGIFFileFromLink(_ link: String) async  {
        do {
            guard let url = URL(string: link) else { return }
            let response = try await URLSession.shared.data(from: url)

            try await PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                let fileName = PHAssetResourceCreationOptions()
                fileName.originalFilename = self.buildGIFSystemURL()
                creationRequest.addResource(with: .photo, data: response.0, options: fileName)
                print("Filename: \(String(describing: fileName.originalFilename))")
            })
            print("File saved")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
