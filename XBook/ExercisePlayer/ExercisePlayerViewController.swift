//
//  ExercisePlayerViewController.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit
import CloudKit

class ExercisePlayerViewController: UIViewController {
    
    let database = CKContainer.default().privateCloudDatabase
    var alertView: UIAlertController!
    let shapelayer = CAShapeLayer()
    var exerciseTimer: Timer?
    var timeCount = 0
    var totalCount = 10
    var isPlaying: Bool = false
    var name: String?
    var actionImage: String? {
        didSet {
            if let image = actionImage {
                self.actionImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    let pauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.primaryColor
        button.setTitle("Pause", for: .normal)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(pauseButtonOnClicked), for: .touchUpInside)
        
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.primaryColor
        button.setTitle("Play", for: .normal)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(playButtonOnClicked), for: .touchUpInside)
        
        return button
    }()
    
    let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.primaryColor
        
        return imageView
    }()
    
    @objc func pauseButtonOnClicked() {
        if (isPlaying) {
            DispatchQueue.main.async {
                self.exerciseTimer?.invalidate()
                self.isPlaying = false
            }
        }
    }
    
    @objc func playButtonOnClicked() {
        if (!isPlaying) {
            DispatchQueue.main.async {
                self.setupTimer()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        var image = UIImage(systemName: "chevron.down")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(dismissView))
        
        setupProgressView()
        setupTimer()
        setupView()
    }
    
    @objc func dismissView() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
        
        saveToCloud()
    }
    
    func saveToCloud() {
        let newExercise = CKRecord(recordType: "Exercises")
        newExercise.setValue(self.timeCount, forKey: "currentCount")
        newExercise.setValue(self.name, forKey: "name")
        newExercise.setValue(self.totalCount, forKey: "totalCount")
        
        database.save(newExercise, completionHandler: { record, error in
            guard record != nil else { return }
            
            if record != nil {
                NotificationCenter.default.post(name: Notification.Name("newRecord"), object: nil, userInfo: ["newRecord": record! as CKRecord])
            }
        })
        
    }
    
    func setupTimer() {
//        self.setupAnimation()
        self.exerciseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimeCode), userInfo: nil, repeats: true)
        self.isPlaying = true
    }
    
    func showSuccessBanner() {

        self.alertView = UIAlertController(title: "Successfully finish \((self.name ?? "") as String)", message: "", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action: UIAlertAction!) in
            self.shareProgress()
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.alertView.dismiss(animated: true, completion: nil)
        }))

        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: self.alertView.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400)
        self.alertView?.view.addConstraint(height)
        
        self.present(self.alertView, animated: true, completion: {
           
            let coverViewAlert = UIView()
            coverViewAlert.translatesAutoresizingMaskIntoConstraints = false
            coverViewAlert.backgroundColor = .primaryColor
            // Add to subview
            self.alertView.view.addSubview(coverViewAlert)
            coverViewAlert.topAnchor.constraint(equalTo: self.alertView.view.topAnchor, constant: 75).isActive = true
            coverViewAlert.leadingAnchor.constraint(equalTo: self.alertView.view.leadingAnchor).isActive = true
            coverViewAlert.trailingAnchor.constraint(equalTo: self.alertView.view.trailingAnchor).isActive = true
            coverViewAlert.bottomAnchor.constraint(equalTo: self.alertView.view.bottomAnchor, constant: -45).isActive = true
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: self.actionImage!)
            imageView.contentMode = .scaleAspectFit
            // Add to coverview
            coverViewAlert.addSubview(imageView)
            imageView.centerYAnchor.constraint(equalTo: coverViewAlert.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: coverViewAlert.centerXAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
        })
    
    }
    
    func shareProgress() {
        // image to share
        let image = UIImage(named: self.actionImage!)

        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    
    @objc func runTimeCode() {
        timeCount += 1

        let strokeEnd = CGFloat(timeCount)/CGFloat(totalCount)
        shapelayer.strokeEnd = strokeEnd
        
        if timeCount == self.totalCount {
            self.exerciseTimer?.invalidate()
            self.timeCount = 0
            self.showSuccessBanner()
        }
    }
    
    func setupView() {
        view.addSubview(pauseButton)
        pauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(playButton)
        playButton.topAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: 16).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(actionImageView)
        actionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        actionImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        actionImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    }
    
    func setupProgressView() {
        let center = CGPoint(x: view.center.x, y: view.center.y - 100)
        
        // create track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.primaryColor.withAlphaComponent(0.5).cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
        
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = UIColor.primaryColor.cgColor
        shapelayer.lineWidth = 10
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.lineCap = .round
        shapelayer.strokeEnd = 0
        
        view.layer.addSublayer(shapelayer)
        
    }
    
}
