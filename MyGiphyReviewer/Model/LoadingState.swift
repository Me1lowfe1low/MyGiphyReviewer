// Created for MyGiphyReviewer on 22.04.2023
//  LoadingState.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

/// LoadingState holds content state of view model
enum LoadingState: Comparable {
    case readyForFetch
    case isLoading
    case error(String)
    case initialState
    case allIsLoaded
    
    var readableFormat: String {
        switch self {
            case .readyForFetch:
                return "Data is ready for fetching"
            case .isLoading:
                return "Data is loading"
            case .error(let message):
                return "Error: \(message)"
            case .initialState:
                return "Initial state"
            case .allIsLoaded:
                return "All data is gathered"
        }
    }
}
