//
//  LoginViewController.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "backgroundLogin")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let logoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "XBookIcon")
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    let signInWithAppleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in with Apple", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "appleIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(signInWithAppleButtonOnClicked), for: .touchUpInside)
    
        return button
    }()
    
    @objc func signInWithAppleButtonOnClicked() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        let navController: UINavigationController = (self?.navigationController!)!
                        navController.viewControllers = [MainViewController()]
                        UIApplication.shared.windows.first?.rootViewController = navController
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(coverImage)
        coverImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(logoIcon)
        logoIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        logoIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoIcon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        logoIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(signInWithAppleButton)
        signInWithAppleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInWithAppleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        signInWithAppleButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signInWithAppleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signInWithAppleButton.layer.cornerRadius = 6
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

}
