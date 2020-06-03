//
//  RecentExerciseCell.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit

class RecentExerciseCell: BaseCell {
    
    var currentCount: Int? {
        didSet {
            if let count = currentCount {
                self.countLabel.text = "Last exercise \(count) times"
            }
        }
    }
    
    var name: String? {
        didSet {
            if let title = name {
                titleLabel.text = title
                
                if (title == "Jump Rope") {
                    actionImageView.image = UIImage(named: "jumpRope")
                }
                
                if (title == "Squat Jump") {
                    actionImageView.image = UIImage(named: "squatJump")
                }
                
                if (title == "Jumping Jacks") {
                    actionImageView.image = UIImage(named: "jumping")
                }
            }
        }
    }
    
    var currentDate: String? {
        didSet {
            if let date = currentDate {
                self.lastDateLabel.text = date
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
    
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
    
        return label
    }()
    
    let lastDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
    
        return label
    }()
    
    let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(named: "rectangleImage")
        
        return imageView
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
        titleLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 32).isActive = true
        
        coverImageView.addSubview(countLabel)
        countLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -48).isActive = true
        countLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 32).isActive = true
        
        coverImageView.addSubview(lastDateLabel)
        lastDateLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -24).isActive = true
        lastDateLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 32).isActive = true
    }
}
