//
//  pageCell.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit

class PageCell: BaseCell {
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "backgroundPage")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()

        addSubview(coverImage)
        coverImage.topAnchor.constraint(equalTo: topAnchor, constant: -10).isActive = true
        coverImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        coverImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
