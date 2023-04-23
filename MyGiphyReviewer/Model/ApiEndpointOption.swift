// Created for MyGiphyReviewer on 21.04.2023
//  ApiEndpointOption.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

enum ApiEndpointOption: CaseIterable, Comparable {
    case trending
    case artists
    case clips
    case stories
    case stickers
    
    var title: String {
        switch self {
            case .trending:
                return "Trending"
            case .artists:
                return "Artists"
            case .clips:
                return "Clips"
            case .stories:
                return "Stories"
            case .stickers:
                return "Stickers"
        }
    }
}
