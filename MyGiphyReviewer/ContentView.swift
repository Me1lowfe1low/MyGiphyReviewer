//
//  ContentView.swift
//  MyGiphyReviewer
//
//  Created by Dmitrii Gordienko on 19.04.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let gifAPI = GIPHYAPIService()
        
        VStack {
            NavigationView {
                MainView()
                    .environmentObject(gifAPI)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





