// Created for MyGiphyReviewer on 20.04.2023
//  GIPHYAPIViewModel.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import Foundation

class GIPHYAPIViewModel: ObservableObject {
    private var apiKey = "91NSZN24dZULJSHQkAsOWynsEcR1xQBw"
    
    func buildURLRequest(for searchObject: String) -> URL {
        URL(string:"https://api.giphy.com/v1/gifs/search?api_key=\(apiKey)&q=\(searchObject)&limit=25&offset=0&rating=g&lang=en")!
    }
    
    private func buildGIFURLString(for gifID: String) -> String {
        "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDQyZjczZDAwYjkzZDQ1MjhkNmNhZDkyYzVhMTcxNzVlY2UxMzQwNSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/" + gifID + "/giphy.gif"
    }
    
    func fetchOneSampleOfData(urlString: String, completionHandler: @escaping (Data?, NSError?) -> Void ) {
        var tempData = Data()
        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            DispatchQueue.main.async{
                tempData = data!
                completionHandler(tempData,nil)
            }
        }
        task.resume()
    }
    
    func fetchMultipleRecords(urlString: URL, completionHandler: @escaping (GifGridItem?, NSError?) -> Void ) {
            let task = URLSession.shared.dataTask(with: urlString) { gatheredData, response, error in
                if let data = gatheredData {
                    if let decodedGiphy = try? JSONDecoder().decode(GifDataStructure.self, from: data) {
                        
                        DispatchQueue.main.async{
                            decodedGiphy.data.forEach { gifData in
                                let randomHeight = CGFloat.random(in: 100 ... 400)
                                let gifURL: String = self.buildGIFURLString(for: gifData.id)
                                let gridItems =
                                GifGridItem(height: randomHeight,
                                            gifURL: gifURL,
                                            gifID: gifData.id)
                                completionHandler(gridItems,nil)
                                //print("url: \(gifURL) and id: \(gifData.id)" )
                            }
                        }
                    }
                }
            }
            task.resume()
    }
}




