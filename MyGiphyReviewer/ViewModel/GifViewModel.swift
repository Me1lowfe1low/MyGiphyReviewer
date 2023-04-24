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
    
    var columns = [Column](repeating: Column(), count: 2)
    var columnsHeight = [CGFloat](repeating: 0, count: 2)
    
    init(queryString: String = "",
         giphyAPI: GIPHYAPIService = GIPHYAPIService(),
         logger: Logger = Logger(subsystem: "MyGiphyReviewer", category: "GifViewModel"),
         endpoint: ApiEndpointOption = .trending,
         loadingState: LoadingState = .initialState,
         maxIndex: Int = 0,
         limit: Int = 10,
         page: Int = 0
    ) {
        self.searchObject = queryString
        self.giphyAPI = giphyAPI
        self.logger = logger
        self.loadingState = loadingState
        self.endpoint = endpoint
        self.maxIndex = maxIndex
        self.limit = limit
        self.page = page 
    }
    
    /// Method to errase data on tab changing
    func changeTab(endpoint: ApiEndpointOption) {
        self.endpoint = endpoint
        self.gridItems = []
        updateSearchObject(tab: endpoint)
        self.loadingState = .initialState
        self.page = 0
        self.columns = [Column](repeating: Column(), count: 2)
        self.columnsHeight = [CGFloat](repeating: 0, count: 2)
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
            var localColumns = self.columns
            
            await MainActor.run { [weak self] in
                fetchedData.data.forEach { gifData in
                    let randomHeight = CGFloat.random(in: 100 ... 400)
                    let gifURL: String = giphyAPI.buildGIFURLString(for: gifData.id)
                    logger.debug("Current url: \(gifURL)")
                    let tempGridItem = GifGridItem(index: self?.maxIndex ?? 0, height: randomHeight, gifURL: gifURL, gifGIPHYURL: gifData.url, gifID: gifData.id)
                    self?.gridItems.append(tempGridItem)
                    self?.maxIndex += 1
                    print("\(self?.maxIndex)")
                    self?.loadingState = (fetchedData.data.count == self?.limit) ? .readyForFetch : .allIsLoaded
                    
                    var smallestColumnIndex = 0
                    var smallestHeight = self?.columnsHeight[0] ?? 100
                    for i in 1 ..< 2 {
                        let currentHeight = self?.columnsHeight[i] ?? 100
                        if currentHeight < smallestHeight {
                            smallestHeight = currentHeight
                            smallestColumnIndex = i
                        }
                    }
                    /// Increasing size of the column
                    localColumns[smallestColumnIndex].gridItems.append(tempGridItem)
                    self?.columnsHeight[smallestColumnIndex] += tempGridItem.height
                }
                self?.page += 1
                self?.columns = localColumns
                print("Columns \(localColumns)")
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
