// Created for MyGiphyReviewer on 20.04.2023
//  GIPHYAPIService.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation
import OSLog

/// Service that brings GIPHY API
class GIPHYAPIService: ObservableObject {
    private let logger: Logger
    private let cache: NSCache<NSString, NSData>
    private let apiKey: String = "91NSZN24dZULJSHQkAsOWynsEcR1xQBw"
    
    
    /// Initialisating cache with parameters and logging
    init(cache: NSCache<NSString, NSData> = .init()) {
        self.cache = cache
        self.cache.countLimit = 50
        self.logger = Logger(subsystem: "MyGiphyReviewer", category: "GIPHYAPIService")
    }
    
    /// Gathering URL string accoridng to the chosen endpoint
    func parseEndpoint(for urlData: URLDataModel) -> String {
        var tempURL = ""
        let prefix = "https://"
        logger.trace("limit: \(urlData.limit), offset: \(urlData.offset)")
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
    
    /// Preparing URL with provided data
    func prepareURL(for urlData: URLDataModel) -> URL {
        let tempURL = parseEndpoint(for: urlData)
        
        guard let url = URL(string: tempURL) else {
            logger.error("Error. Incorrect URL. Providing default URL, some issues occured")
            return URL(string: "https://api.giphy.com/v1/gifs/search?api_key=91NSZN24dZULJSHQkAsOWynsEcR1xQBw&q=memes&limit=25&offset=0&rating=g&lang=en")!
        }
        return url
    }
    
    /// Method to load GIF file from the single URL string.
    /// This method will provide Data to the View Model, additionally it will cache this Data
    func fetchOneSampleOfData(_ item: GifGridItem) async -> Data  {
        logger.trace("Checking gif in cache with gifID: \(item.gifID)")
        var gifData = Data()
        do {
            if let cached = cache.object(forKey: item.gifID as NSString) {
                logger.trace("Using cached data")
                gifData = cached as Data
            } else {
                logger.trace("Loading fresh data")
                guard let url = URL(string: item.gifURL) else { return gifData }
                let response = try await URLSession.shared.data(from: url)
                gifData = response.0
                cache.setObject(gifData as NSData, forKey: item.gifID as NSString)
            }
            logger.trace("Data is passed to the ViewModel")
            return gifData
        } catch let error {
            logger.error("Error: \(error.localizedDescription)")
            return gifData
        }
    }
    
    /// Method to provide View Model data for grid construction
    func fetchGifs(url: URL) async -> GifDataStructure {
        do {
            let response = try await URLSession.shared.data(from: url)
            let decodedGiphy = try JSONDecoder().decode(GifDataStructure.self, from: response.0)
            return decodedGiphy
        } catch let error {
            logger.error("Error in fetching/decoding step: \(error.localizedDescription)")
            return GifDataStructure(data: [DataStructure(id: "NaN", url: "NaN")])
        }
    }
}



