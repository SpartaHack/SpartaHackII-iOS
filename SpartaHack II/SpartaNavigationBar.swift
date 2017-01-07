//
//  SpartaNavigationBar.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 11/30/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

/*
 This subclass is needed to modify the height of the NavigationBar.
 All credit goes to this thorough StackOverflow post: http://stackoverflow.com/questions/28705442/ios-8-swift-xcode-6-set-top-nav-bar-bg-color-and-height
 */

protocol SpartaNavigationBarDelegate: class {
    func onThemeChange()
}

class SpartaNavigationBar: UINavigationBar {
    private var themeSelection = UserDefaults.standard.integer(forKey: "themeKey")
    private var animating: Bool = false
    ///The height you want your navigation bar to be of
    static let navigationBarHeight: CGFloat = 70
    
    ///The difference between new height and default height
    static let heightIncrease:CGFloat = navigationBarHeight - 44
    
    private let borderSize: CGFloat = 1.5
    private var bottomBorder: UIView = UIView()
    private var profileButton: UIButton = UIButton.init(type: .custom)
    private var firstName: UILabel = UILabel()
    
    weak var spartaNavigationBarDelegate: SpartaNavigationBarDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func imageTapped(img: UITapGestureRecognizer) {
        if self.animating {
            return
        }
        if themeSelection == 0 {
            themeSelection = 1
            Theme.darkTheme()
            let diamondImageView = img.view as! UIImageView
            UIView.transition(with: diamondImageView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                diamondImageView.image = Theme.getDiamondImage()
            },
                              completion: nil)
        }
        else {
            themeSelection = 0
            Theme.lightTheme()
            let diamondImageView = img.view as! UIImageView
            UIView.transition(with: diamondImageView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                diamondImageView.image = Theme.getDiamondImage()
            },
                              completion: nil)
        }
        
        self.animating = true
        UIView.animate(withDuration: 1.0, animations: {
            self.barTintColor = Theme.backgroundColor
            self.tintColor = Theme.tintColor
        }, completion: { _ in
            self.animating = false
        })
        
        // This must be a SpartaTableViewController!
        let topController = UIApplication.topViewController()
        if let topController = topController as? SpartaTableViewController {
            topController.updateTheme(animated: true)
        }
        
        // tabBar.tintColor = .
        spartaNavigationBarDelegate.onThemeChange()
    }
    
    private func initialize() {
        let diamondImage = UIImageView(image: UIImage(named: "diamond"))
        diamondImage.frame = CGRect(x: 0, y: 0, width: 50, height: 51)
        
        diamondImage.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        //Add the recognizer to your view.
        diamondImage.addGestureRecognizer(tapRecognizer)
        
        self.topItem?.titleView = diamondImage
        
        profileButton.setImage(UIImage.init(named: "profile"), for: UIControlState.normal)
        // ToDo: Hook this up to the Profile page
        profileButton.addTarget(self, action:#selector(presentProfileView), for: .touchUpInside)
        
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        let profileButtonItem = UIBarButtonItem.init(customView: profileButton)
        
        self.topItem?.setRightBarButtonItems([profileButtonItem], animated: true)
        
        self.addSubview(firstName)
        
        if let firstNameString = UserManager.sharedInstance.getFirstName() {
            self.setName(to: firstNameString)
        }
        
        firstName.textAlignment = .center
        firstName.font = UIFont(name: "Lato", size: 12.0)

        
        // Cool border
        self.addSubview(self.bottomBorder)
        
        let shift = SpartaNavigationBar.heightIncrease/2
        
        ///Transform all view to shift upward for [shift] point
        self.transform =
            CGAffineTransform(translationX: 0, y: -shift)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.barStyle = .default
        self.barTintColor = Theme.backgroundColor
        self.tintColor = Theme.tintColor
        
        let shift = SpartaNavigationBar.heightIncrease/2
        
        ///Move the background down for [shift] point
        let classNamesToReposition: [ String ] = [ "_UIBarBackground" ]
        for view: UIView in self.subviews {
            if classNamesToReposition.contains(NSStringFromClass(type(of: view))) {
                let bounds: CGRect = self.bounds
                var frame: CGRect = view.frame
                frame.origin.y = bounds.origin.y + shift - 20.0
                frame.size.height = bounds.size.height + 20.0
                view.frame = frame
            }
        }
        
        self.bottomBorder.frame = CGRect(x: 0,
                                         y: self.frame.size.height + shift,
                                         width: self.frame.size.width,
                                         height: self.borderSize)
        Theme.setHorizontalGradient(on: self.bottomBorder, of: .darkGradient)
        
        // Set the user initials under the profile icon
        firstName.frame = profileButton.frame
        firstName.bounds = profileButton.bounds
        if let profileImageFrame = profileButton.imageView?.frame {
            firstName.frame.origin.y += profileImageFrame.size.height - 7.0
        }
        firstName.frame.origin.x = profileButton.frame.origin.x
        firstName.adjustsFontSizeToFitWidth = true
        
        
        firstName.textColor = Theme.primaryColor
    }
    
    func presentProfileView() {
        if !UserManager.sharedInstance.isUserLoggedIn() {
            let loginView: LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
            UIApplication.shared.keyWindow?.rootViewController?.present(loginView, animated: true, completion: nil)
            return
        }
        let profileView: ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        UIApplication.shared.keyWindow?.rootViewController?.present(profileView, animated: true, completion: nil)
    }
    
    func setName(to newName: String) {
        self.firstName.text = newName
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let amendedSize:CGSize = super.sizeThatFits(size)
        let newSize:CGSize = CGSize(width: amendedSize.width, height: SpartaNavigationBar.navigationBarHeight);
        return newSize;
    }
}

