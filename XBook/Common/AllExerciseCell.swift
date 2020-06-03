//
//  AllExerciseCell.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit

class AllExerciseCell: BaseCell {
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "rectangleImage")
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 4
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let playButton: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(coverImageView)
        coverImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        coverImageView.addSubview(actionImageView)
        actionImageView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: 16).isActive = true
        actionImageView.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor).isActive = true
        actionImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        actionImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        coverImageView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: 24).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 16).isActive = true
        
        coverImageView.addSubview(subTitleLabel)
        subTitleLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -24).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 16).isActive = true
        subTitleLabel.widthAnchor.constraint(equalToConstant: frame.width * 0.5).isActive = true
        
        coverImageView.addSubview(playButton)
        playButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: -8).isActive = true
        playButton.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
