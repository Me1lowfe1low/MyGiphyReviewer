// Created for MyGiphyReviewer on 19.04.2023
//  Column.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

struct Column: Identifiable {
    let id = UUID()
    var gridItems = [GifGridItem]()
}
