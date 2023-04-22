// Created for MyGiphyReviewer on 21.04.2023
//  TabBarModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

enum TabBarModel: CaseIterable {
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
