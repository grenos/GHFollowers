//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 23/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    // init the elements for the screen
    let logoImageView = UIImageView()
    let userNameTextFiled = GFTextField()
    let CTAButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    // get access to the top constraint of the logo image so we can change its position based on the phone's screen size
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    // computed property to control if inout is empty
    var isUsernameEntered: Bool {
        return !userNameTextFiled.text!.isEmpty
    }
    

    // component did mount
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureLogoImageView()
        configureTextField()
        configureCTAButton()
        createDismissKeyboardTapGesture()
    }
    
    // component will focus
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // hide navbar on this screen
        // called in this lifecycle because we need to hide it everytime we enter this screen
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // adds a custom gesture
    func createDismissKeyboardTapGesture () {
        // target -> the view i will tap, action -> what to do when i tap it
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        // add the new gesture to the view
        view.addGestureRecognizer(tap)
    }
    
    
    // clean input on shake
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        userNameTextFiled.text = ""
    }
    
    
    // @objc because this func uses objectice-c language
    @objc func pushFollowerListVC () {
        
        // if input is empty -> show Alert
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀", buttonTitle: "Close")
            return
        }
        
        let followerListVC = FollowerListVC()
        // pass the value of the input to the FollowersVC View
        followerListVC.username = userNameTextFiled.text
        // same for the navigation title
        followerListVC.title = userNameTextFiled.text
        // finally handle the navigation
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    
    
    // MARK: UI Functions
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        
        NSLayoutConstraint.activate([
            // place it on top after the safeArea and give it a margin of 80
            logoImageViewTopConstraint,
            // center the image in the view horizontally
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // set image height
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            // set width
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    
    func configureTextField() {
        view.addSubview(userNameTextFiled)
        // set as delegate of the textField to this view (to receive the input and pass it arround to other screens)
        userNameTextFiled.delegate = self
        
        NSLayoutConstraint.activate([
            // place textField at the bottom of the imageView with a top margin of 48
            userNameTextFiled.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            // pin one side to the begining of the entire view and give it a margin of 50
            userNameTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            // same thing as above but for the end of the input and the rigth side of the screen
            userNameTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            // set height
            userNameTextFiled.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    func configureCTAButton() {
        view.addSubview(CTAButton)
        
        // call pushFollowerListVC whenever we tap the button
        CTAButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // set button on bottom after the safeArea and give a margin of 50
            CTAButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            // pin to left of screen and give a margin of 50
            CTAButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            // same as above but from the right side
            CTAButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            // give it a height of 50
            CTAButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
}


// use an extension for this to avoid clutter and write cleaner code (makes no difference in performance)
// conform to the delegate of the input
extension SearchVC: UITextFieldDelegate {
    
    // SearchVC listens to the return button of the keyboard of the textFeild
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // calls function on tap of return key of keyboard
        pushFollowerListVC()
        return true
    }
    
}
