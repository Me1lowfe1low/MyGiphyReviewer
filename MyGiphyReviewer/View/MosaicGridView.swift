// Created for MyGiphyReviewer on 19.04.2023
//  MosaicGridView.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

/// MosaicGridView - view that shows elements in mosaic layout.
///  As input it requests - structure with gifs
struct MosaicGridView: View {
    let columns: [Column]
    private var numOfColumns: Int = 2
    
    /// Customized init required to calculate elements layout inside of the mosaic grid
    init(gridItems: [GifGridItem] ) {
        var columns = [Column]()
        for _ in 0 ..< numOfColumns {
            columns.append(Column())
        }
        
        /// Needed for calculation of the smallest height of column
        var columnsHeight = [CGFloat](repeating: 0, count: numOfColumns)
        
        /// Placing items in the grid with coplience to their sizes
        for gridItem in gridItems {
            var smallestColumnIndex = 0
            var smallestHeight = columnsHeight.first!
            for i in 1 ..< columnsHeight.count {
                let currentHeight = columnsHeight[i]
                if currentHeight < smallestHeight {
                    smallestHeight = currentHeight
                    smallestColumnIndex = i
                }
            }
            
            /// Increasing size of the column
            columns[smallestColumnIndex].gridItems.append(gridItem)
            columnsHeight[smallestColumnIndex] += gridItem.height
        }
        self.columns = columns
    }
    
    var body: some View {
        HStack(alignment: . top, spacing: 10) {
            ForEach(columns) { column in
                LazyVStack(spacing: 10) {
                    ForEach(column.gridItems) { gridItem in
                        SingleGifView(gridItem: gridItem)
                    }
                }
            }
        }
    }
}

struct MosaicGridView_MainView_Previews: PreviewProvider {
    static var previews: some View {
        let gifAPI = GIPHYAPIViewModel()
        MainView()
            .environmentObject(gifAPI)
    }
}

