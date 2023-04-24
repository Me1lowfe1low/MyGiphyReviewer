// Created for MyGiphyReviewer on 19.04.2023
//  Column.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

/// Column struct holds data for mosaic grid
struct Column: Identifiable, Hashable {
    let id = UUID()
    var gridItems = [GifGridItem]()
}
