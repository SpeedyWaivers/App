//
//  LandingVC.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/17/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AlamofireImage

class LandingVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var landingView: UIView!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    
    
    // MARK: Variables
    private lazy var settingsVC: SettingsVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = SettingsVC(nibName :"SettingsVC",bundle : nil)
        viewController.pressedClose = {
            self.remove(asChildViewController: self.settingsVC)
            
            if self.landingView.subviews.count == 1 {
                self.beginButton.isHidden = false
            }
        }
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var registrationVC: RegistrationVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = RegistrationVC(nibName :"RegistrationVC",bundle : nil)
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    
    //
    let bag = DisposeBag()
    var isUser: Bool = false
    var tap: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
        self.view.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 3
    }
    
    func setupUI() {
        
        beginButton.addLayerEffects(cornerRadius: 6)
        
        if let url =  UserDefaults.standard.url(forKey: "avatar") {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                backImageView.image = image
            }
        } else {
            beginButton.isHidden = true
            addChild(settingsVC)
        }
        
        if UserDefaults.standard.string(forKey: "x-access-token") != nil {
            //may require token validate from backend
        } else {
            beginButton.isHidden = true
            addChild(settingsVC)
        }
        
    }
    
    func addObservers() {
        beginButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedBeginButton()
        }
        .disposed(by: bag)
    }
    
    func pressedBeginButton() {
        beginButton.isHidden = true
        add(asChildViewController: registrationVC)
    }
    
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
        beginButton.isHidden = true
        add(asChildViewController: settingsVC)
    }
    
}
extension LandingVC {
    
    // MARK: Functions
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        landingView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = landingView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}
