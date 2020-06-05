//
//  SettingsVC.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/10/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol SettingsUserSaveSuccessDelegate {
    func settingsUserSaved()
}

class SettingsVC: BaseVC {
    
    // MARK: Outlets
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    
    // MARK: Variables
    let bag = DisposeBag()
    let vm: SettingsVM  = SettingsVM()
    var pressedClose: () -> () = {}
    var delegate: SettingsUserSaveSuccessDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addObservers()
    }
    
    func setupUI() {
        
        [closeButton, saveButton].forEach { (btn) in
            btn?.addLayerEffects(with: .lightGray, borderWidth: 1, cornerRadius: 6)
        }
    }
    
    func addObservers() {
        userNameTF.rx.text
            .orEmpty
            .bind(to: vm.username)
            .disposed(by: bag)
        
        passwordTF.rx.text
            .orEmpty
            .bind(to: vm.password)
            .disposed(by: bag)
        
        imageButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedImagePickerButton()
        }
        .disposed(by: bag)
        
        saveButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedSaveButton()
        }
        .disposed(by: bag)
        
        closeButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedCloseButton()
        }
        .disposed(by: bag)
    }
    
    // handle button pressed events
    
    func pressedImagePickerButton()  {
        showImagePickerAlert(sourceView: self.view, editting: true)
    }
    
    func pressedCloseButton() {
        pressedClose()
    }
    
    func pressedSaveButton() {
    
        vm.validateAndLoginUser { (success, message) in
            if success {
                self.startLoading()
                vm.authenticstionNetworkRequest { [weak self] (success, statusCode, message) in
                    self?.stopLoading()
                    if success {
                        ApplicationService.shared.manageUserDirection()
                        self?.delegate?.settingsUserSaved()
                    } else {
                        AlertProvider(vc: self ?? UIViewController()).showAlert(title: .Error, message: message, action: .init(title: .Dismiss))
                    }
                }
            } else {
                AlertProvider(vc: self).showAlert(title: .Error, message: message, action: .init(title: .Dismiss))
            }
        }
    }
    
    //image upload
    func saveImage(image: UIImage) -> (Bool, URL?) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            return (false, nil)
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return (false, nil)
        }
        
        if !FileManager.default.fileExists(atPath: directory.path!) {
            try? FileManager.default.createDirectory(atPath: directory.path!, withIntermediateDirectories: true, attributes: nil)
        }
        
        do {
            let timestampFilename = "capturedImage.jpeg"  //get the timestamp
            let filePath: URL = directory.appendingPathComponent(timestampFilename)!
            try? data.write(to: filePath, options: [])
            return (true, filePath.absoluteURL)
        } catch {
            print(error.localizedDescription)
            return (false, nil)
        }
    }
}
extension SettingsVC {
    // handling picked image showing and uploading
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            self.backImageView.image = pickedImage
            
            let (success, url) = self.saveImage(image: pickedImage)
            
            if success {
                UserDefaults.standard.set(url!, forKey: "avatar")
            }
        }
    }
}
