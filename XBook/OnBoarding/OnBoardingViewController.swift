//
//  ViewController.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit

class OnBoardingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pages = ["1", "2", "3"]
    
    private let previousButton : UIButton = {
        let button = UIButton(type: .system)
        let custombutton = NSAttributedString(string: "PREV", attributes: [NSAttributedString.Key.kern: 0.2, NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(custombutton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        handleDone(index: pageControl.currentPage )
    }
    
    
    private let nextButton : UIButton = {
        let button = UIButton(type: .system)
        let custombutton = NSMutableAttributedString(string: "NEXT", attributes: [NSAttributedString.Key.kern: 0.2, NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(custombutton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        let index = pageControl.currentPage + 1
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        handleDone(index: pageControl.currentPage)
        if(index == 3) {
            handleDoneClick()
        }
    }
    
    func handleDoneClick(){
        let navController: UINavigationController = self.navigationController!
        navController.viewControllers = [LoginViewController()]
        UIApplication.shared.windows.first?.rootViewController = navController
    }
    
    func handleDone(index: Int){
        if(index == 2) {
            let custombutton = NSMutableAttributedString(string: "DONE", attributes: [NSAttributedString.Key.kern: 0.2, NSAttributedString.Key.foregroundColor: UIColor.white])
            nextButton.setAttributedTitle(custombutton, for: .normal)
            
        } else {
            let custombutton = NSMutableAttributedString(string: "NEXT", attributes: [NSAttributedString.Key.kern: 0.2, NSAttributedString.Key.foregroundColor: UIColor.white])
            nextButton.setAttributedTitle(custombutton, for: .normal)
        }
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = UIColor(red: 231/255, green: 29/255, blue: 53/255, alpha: 0.2)
        return pc
    }()
    
    fileprivate func setupButtonControls() {
        
        let bottomControlsSrackView = UIStackView(arrangedSubviews: [previousButton,pageControl,nextButton])
        bottomControlsSrackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsSrackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsSrackView)
        NSLayoutConstraint.activate([bottomControlsSrackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),bottomControlsSrackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),bottomControlsSrackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),bottomControlsSrackView.heightAnchor.constraint(equalToConstant: 48)])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        handleDone(index: pageControl.currentPage )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupButtonControls()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = .black
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellid")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PageCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
}

