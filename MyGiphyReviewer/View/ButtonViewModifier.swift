// Created for MyGiphyReviewer on 20.04.2023
//  ButtonViewModifier.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import SwiftUI

struct ButtonViewModifier: ViewModifier {
    let font: Font
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .bold()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .buttonStyle(.plain)
            .background(backgroundColor)
            .padding(.horizontal)
    }
}

struct ButtonViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test sample")
            .modifier(ButtonViewModifier(font: .title2, backgroundColor: .blue))
    }
}
