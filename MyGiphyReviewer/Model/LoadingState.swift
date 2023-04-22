// Created for MyGiphyReviewer on 22.04.2023
//  LoadingState.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

enum LoadingState: Comparable {
    case readyForFetch
    case isLoading
    case error(String)
    case initialState
}
