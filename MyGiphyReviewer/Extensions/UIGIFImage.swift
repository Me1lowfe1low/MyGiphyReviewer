// Created for MyGiphyReviewer on 19.04.2023
//  UIGIFImage.swift
//  MyGiphyReviewer
//
//
//    dmgordienko@gmail.com 2023

import UIKit

class UIGIFImage: UIView {
    private let imageView = UIImageView()
    private var data: Data?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String) {
        self.init()
        initView()
    }
    
    convenience init(data: Data) {
        self.init()
        self.data = data
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
    }
    
    func updateGIF(data: Data) {
        imageView.image = UIImage.gifImage(data: data)
    }
    
    private func initView() {
        imageView.contentMode = .scaleAspectFit
    }
}
