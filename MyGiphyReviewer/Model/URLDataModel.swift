// Created for MyGiphyReviewer on 23.04.2023
//  URLDataModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

/// DTO for communication between ViewModel and  GIPHY API Service
struct URLDataModel {
    var searchObject: String
    var limit:  Int = 10
    var offset: Int = 0
    var rating: String = "g"
    var lang: String = "en"
    var endpoint: ApiEndpointOption = .trending
}
