// Created for MyGiphyReviewer on 19.04.2023
//  GifViewModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation
import Photos
import OSLog


/// View Model for grid view
@MainActor
class GifViewModel: ObservableObject {
    @Published var gridItems = [GifGridItem]()
    @Published var loadingState: LoadingState
    @Published var endpoint: ApiEndpointOption
    private let logger: Logger
    private let giphyAPI: GIPHYAPIService
    
    private var searchObject: String
    
    private let limit: Int
    var page: Int
    var maxIndex: Int
    
    init(queryString: String = "", giphyAPI: GIPHYAPIService = GIPHYAPIService()) {
        self.searchObject = queryString
        self.logger = Logger(subsystem: "MyGiphyReviewer", category: "GifViewModel")
        self.giphyAPI = giphyAPI
        self.endpoint = .trending
        
        self.page = 0
        self.limit = 10
        
        self.maxIndex = 0
        
        self.loadingState = .initialState
    }
    
    /// Method to errase data on tab changing
    func changeTab(endpoint: ApiEndpointOption) {
        self.endpoint = endpoint
        self.gridItems = []
        updateSearchObject(tab: endpoint)
        self.loadingState = .initialState
        self.page = 0
        logger.trace("current tab: \(endpoint.title)")
        logger.trace("state: \(self.loadingState.readableFormat), gridCount: \(self.gridItems.count), page: \(self.page)")
    }
}


extension GifViewModel {
    /// Method to fill grid with gifs placeholders, adding supplemental data to the grid elements
    func fetchRecords() {
        logger.trace("Current tab: \(self.endpoint.title), state: \(self.loadingState.readableFormat)")
        guard self.loadingState == .readyForFetch || self.loadingState == .initialState else {
            logger.trace("Inaprropriate state")
            return
        }
        let url = buildURLRequest(endpoint: endpoint, for: searchObject)
        logger.debug("\(url)")
        Task {
            self.loadingState = .isLoading
            logger.trace("Current state: \(self.loadingState.readableFormat)")
            let fetchedData = await giphyAPI.fetchGifs(url: url)
            await MainActor.run { [weak self] in
                fetchedData.data.forEach { gifData in
                    let randomHeight = CGFloat.random(in: 100 ... 400)
                    let gifURL: String = (self?.buildGIFURLString(for: gifData.id))!
                    logger.debug("Current url: \(gifURL)")
                    self?.gridItems.append(GifGridItem(index: self?.maxIndex ?? 0, height: randomHeight, gifURL: gifURL, gifGIPHYURL: gifData.url, gifID: gifData.id))
                    self?.maxIndex += 1
                    print("\(self?.maxIndex)")
                    self?.loadingState = (fetchedData.data.count == self?.limit) ? .readyForFetch : .allIsLoaded
                }
                self?.page += 1
            }
        }
        logger.trace("FetchRecords end state: \(self.loadingState.readableFormat)")
    }
}

extension GifViewModel {
    /// Method to build URL, at this point offset is being calculated and gathere data is passed to GIPHY API Service
    func buildURLRequest(endpoint: ApiEndpointOption, for searchObject: String) -> URL {
        let offset: Int = self.page * self.limit
        let urlData: URLDataModel = URLDataModel(searchObject: self.searchObject, limit: self.limit, offset: offset, rating: "g", lang: "en", endpoint: endpoint)
        let url = giphyAPI.prepareURL(for: urlData)
        return url
    }
    
    /// Method to change search string
    func updateSearchObject(tab: ApiEndpointOption) {
        var searchOption: String {
            switch tab {
                case .trending:
                    return ""
                case .stickers:
                    return ""
                default:
                    return tab.title
            }
        }
        self.searchObject = searchOption
    }
    
    /// Method to recreate URL for gif
    private func buildGIFURLString(for gifID: String) -> String {
        "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDQyZjczZDAwYjkzZDQ1MjhkNmNhZDkyYzVhMTcxNzVlY2UxMzQwNSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/" + gifID + "/giphy.gif"
    }
    
    /// Method to provide new gif name with current timestamp to make it unique
    private func buildGIFSystemURL() -> String {
        let currentTime = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmssSSS"
        let fileTimeSuffix = formatter.string(from: currentTime)
        return "GIPHY_" + fileTimeSuffix + ".gif"
    }
    
    /// Supplemental method to provide current state of the grid
    func printCurrentState() {
        print(self.loadingState)
    }
}

extension GifViewModel {
    /// Method to save gif to the Photo path with predefined name
    func saveGifFile(_ item: GifGridItem) async {
        do {
            let gifData = await giphyAPI.fetchOneSampleOfData(item)
            logger.trace("File gathered")
            try await PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                let fileName = PHAssetResourceCreationOptions()
                fileName.originalFilename = self.buildGIFSystemURL()
                creationRequest.addResource(with: .photo, data: gifData, options: fileName)
            })
            logger.trace("File saved")
            
        } catch let error {
            logger.error("Error: \(error.localizedDescription)")
        }
    }
}
