// Created for MyGiphyReviewer on 22.04.2023
//  LoadingState.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

enum LoadingState: Comparable {
    case good
    case isLoading
    case allIsLoaded
    case error(String)
}
