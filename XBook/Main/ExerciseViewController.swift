//
//  ExerciseViewController.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit
import CloudKit

class ExerciseViewController: UIViewController {
    
    let database = CKContainer.default().privateCloudDatabase
    var allExcerciseCellId: String = "ALL_EXERCISE_CELL"
    var recentExerciseCellId: String = "RECENT_CELL"
    var exercises = [CKRecord]()
    var newRecord: CKRecord?
    var allExercise: [[String: String]] = [["name": "Jump Rope", "actionImage": "jumpRope", "description": "Loren Ipsum asdasdsadsad fasfas fasfasfa fafasf vasfsafsafsafasf fasfasfasfsafasf"], ["name": "Squat Jump", "actionImage": "squatJump", "description": "Loren Ipsum 2 fasfasfsaf faafasfasfafa fafsasfasfas fasfsaf asfsafsafsaf asfasfasfaf asfasfas"], ["name": "Jumping Jacks", "actionImage": "jumping", "description": "Loren Ipsum 3 safasfsaf fasfsafasfas fsafasfsafasf fasfasfasfa fafasfaf fafaf"]]
    
    let segmentedControl: UISegmentedControl = {
        let items = ["All Exercise", "Recent"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColor]
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.addTarget(self, action: #selector(changeTab), for: .valueChanged)
        segmentedControl.backgroundColor = UIColor.primaryColor
        
        return segmentedControl
    }()
    
    @objc func changeTab(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            recentExerciseCollectionView.isHidden = true
            allExerciseCollectionView.isHidden = false
        case 1:
            allExerciseCollectionView.isHidden = true
            recentExerciseCollectionView.isHidden = false
        default:
            break;
        }
    }
    
    lazy var allExerciseCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AllExerciseCell.self, forCellWithReuseIdentifier: self.allExcerciseCellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var recentExerciseCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecentExerciseCell.self, forCellWithReuseIdentifier: self.recentExerciseCellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    @objc func playExercise(sender: CustomButton) {
        let exercisePlayer = ExercisePlayerViewController()
        exercisePlayer.name = sender.name
        exercisePlayer.actionImage = sender.actionImage
        exercisePlayer.hidesBottomBarWhenPushed = true
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(exercisePlayer, animated: false)
        
    }
    
    func getExercises() {
        let query = CKQuery(recordType: "Exercises", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        database.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            guard let records = records else { return }
            
            DispatchQueue.main.async {
                self.exercises = records
                self.recentExerciseCollectionView.reloadData()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "EXERCISE"
        var image = UIImage(systemName: "person.crop.circle.fill")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: nil, action: nil)
        
        setupView()
        getExercises()
        NotificationCenter.default.addObserver(self, selector: #selector(onRefresh), name: NSNotification.Name(rawValue: "newRecord"), object: .none)
           
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("newRecord"), object: nil)
    }
    
    @objc func onRefresh(_ notification: Notification) {
        let newRecord: CKRecord = (notification.userInfo?["newRecord"] as? CKRecord)!
        self.newRecord = newRecord
    
        DispatchQueue.main.async {
            self.exercises.insert(self.newRecord!, at: 0)
            self.recentExerciseCollectionView.reloadData()
        }
    }
    
    func setupView() {
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(allExerciseCollectionView)
        allExerciseCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16).isActive = true
        allExerciseCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        allExerciseCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        allExerciseCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(recentExerciseCollectionView)
        recentExerciseCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16).isActive = true
        recentExerciseCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        recentExerciseCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        recentExerciseCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

extension ExerciseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == self.allExerciseCollectionView) {
            return allExercise.count
        } else {
            let top5 = exercises.prefix(5)
            return top5.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == allExerciseCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.allExcerciseCellId, for: indexPath) as! AllExerciseCell
            cell.playButton.addTarget(self, action: #selector(playExercise), for: .touchUpInside)
            cell.playButton.name = allExercise[indexPath.row]["name"]
            cell.playButton.actionImage = allExercise[indexPath.row]["actionImage"]
            let exercise = allExercise[indexPath.row]
            cell.titleLabel.text = exercise["name"]
            cell.subTitleLabel.text = exercise["description"]
            cell.actionImageView.image = UIImage(named: exercise["actionImage"]!)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.recentExerciseCellId, for: indexPath) as! RecentExerciseCell
            
            cell.currentCount = self.exercises[indexPath.row].value(forKey: "currentCount") as? Int
            cell.name = self.exercises[indexPath.row].value(forKey: "name") as? String
            
            let date = self.exercises[indexPath.row].creationDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
            let stringDate = dateFormatter.string(from: date!)
            cell.currentDate = stringDate
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
