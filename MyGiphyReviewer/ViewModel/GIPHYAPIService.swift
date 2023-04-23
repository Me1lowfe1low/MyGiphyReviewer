// Created for MyGiphyReviewer on 20.04.2023
//  GIPHYAPIService.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

class GIPHYAPIService: ObservableObject {
    private let cache: NSCache<NSString, NSData>
    private let apiKey: String = "91NSZN24dZULJSHQkAsOWynsEcR1xQBw"
    
    init(cache: NSCache<NSString, NSData> = .init()) {
        self.cache = cache
        self.cache.countLimit = 50
    }
    
    func parseEndpoint(for urlData: URLDataModel) -> String {
        var tempURL = ""
        let prefix = "https://"
        switch urlData.endpoint {
            case .trending:
                let gifURL = "api.giphy.com/v1/gifs/trending?api_key="
                tempURL = prefix + gifURL + self.apiKey + "&limit=\(urlData.limit)&offset=\(urlData.offset)&rating=" + urlData.rating
                return tempURL
            case .artists:
                let gifURL = "api.giphy.com/v1/gifs/search?api_key="
                tempURL = prefix + gifURL + self.apiKey + "&q=" + urlData.searchObject + "&limit=\(urlData.limit)&offset=\(urlData.offset)&rating=" + urlData.rating + "&lang=" + urlData.lang
                return tempURL
            case .clips:
                let gifURL = "api.giphy.com/v1/gifs/search?api_key="
                tempURL = prefix + gifURL + self.apiKey + "&q=" + urlData.searchObject + "&limit=\(urlData.limit)&offset=\(urlData.offset)&rating=" + urlData.rating + "&lang=" + urlData.lang
                return tempURL
            case .stories:
                let gifURL = "api.giphy.com/v1/gifs/search?api_key="
                tempURL = prefix + gifURL + self.apiKey + "&q=" + urlData.searchObject + "&limit=\(urlData.limit)&offset=\(urlData.offset)&rating=" + urlData.rating + "&lang=" + urlData.lang
                return tempURL
            case .stickers:
                let gifURL = "api.giphy.com/v1/stickers/trending?api_key="
                tempURL = prefix + gifURL + self.apiKey + "&limit=\(urlData.limit)&offset=\(urlData.offset)&rating=" + urlData.rating
                return tempURL
        }
    }
    
    func prepareURL(for urlData: URLDataModel) -> URL {
        let tempURL = parseEndpoint(for: urlData)
        
        guard let url = URL(string: tempURL) else {
            print("Providing default URL, some issues occured")
            return URL(string: "https://api.giphy.com/v1/gifs/search?api_key=91NSZN24dZULJSHQkAsOWynsEcR1xQBw&q=memes&limit=25&offset=0&rating=g&lang=en")!
        }
        return url
    }
    
    func fetchOneSampleOfData(item: GifGridItem) async -> Data {
        if let cached = cache.object(forKey: item.gifID as NSString) { return cached as Data }
        do {
            guard let url = URL(string: item.gifURL) else { return Data() }
            let response = try await URLSession.shared.data(from: url)
            let data = response.0
            cache.setObject(data as NSData, forKey: item.gifID as NSString)
            print("cached item ( index: \(item.index), gifId: \(item.gifID)")
            return data
        } catch let error {
            print(error.localizedDescription)
            return Data()
        }
    }
    
    func fetchGifs(url: URL) async -> GifDataStructure {
        do {
            let response = try await URLSession.shared.data(from: url)
            let decodedGiphy = try JSONDecoder().decode(GifDataStructure.self, from: response.0)
            return decodedGiphy
        } catch let error {
            print("Error in fetching/decoding step: \(error.localizedDescription)")
            return GifDataStructure(data: [DataStructure(id: "NaN", url: "NaN")])
        }
    }
    
    func downloadGIFFile(_ item: GifGridItem) async -> Data  {
        print("Checking gif in cache with gifID: \(item.gifID)")
        var gifData = Data()
        do {
            if let cached = cache.object(forKey: item.gifID as NSString) {
                print("Using cached data")
                gifData = cached as Data
            } else {
                print("Loading fresh data")
                guard let url = URL(string: item.gifURL) else { return gifData }
                let response = try await URLSession.shared.data(from: url)
                gifData = response.0
                cache.setObject(gifData as NSData, forKey: item.gifID as NSString)
            }
            print("Data is passed to the ViewModel")
            return gifData
        } catch let error {
            print(error.localizedDescription)
            return gifData
        }
    }
}



