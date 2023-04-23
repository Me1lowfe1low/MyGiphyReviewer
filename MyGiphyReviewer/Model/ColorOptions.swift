// Created for MyGiphyReviewer on 20.04.2023
//  ColorOptions.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

/// ColorOptions - supplmental enum for gird colours
enum ColorOptions: Int, CaseIterable {
    case first = 0
    case second
    case third
    case fourth
    
    var colorMap: [Color] {
        switch self {
            case .first:
                return [.blue,.cyan,.blue]
            case .second:
                return [.red,.pink,.red]
            case .third:
                return [.green,.mint,.green]
            case .fourth:
                return [.orange,.yellow,.orange]
        }
    }
}
