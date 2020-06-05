//
//  BaseVC.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/17/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit

class BaseVC: UIViewController, LoadingIndicatorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    // MARK: Variables
    
    let baseVM = BaseVM()
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }
}
extension BaseVC {
    func showImagePickerAlert(sourceView: UIView, editting: Bool) {
        let action1 = AlertAction(title: .TakePhoto, style: .default)
        let action2 = AlertAction(title: .ChooseFromLibrary, style: .default)
        
        AlertProvider(vc: self).showActionSheetWithActions(title: nil, message: nil, actions: [action1, action2], sourceView: sourceView) { (action) in
            if action.title ==  .TakePhoto {
                self.provideCameraForImagePicking(editting: editting)
            } else if action.title == .ChooseFromLibrary {
                self.provideGalleryForImagePicking(editting: editting)
            }
        }
    }
    
    // Provide Camera
    func provideCameraForImagePicking(editting: Bool) {
        self.picker.allowsEditing = editting
        self.picker.sourceType = .camera
        self.picker.cameraCaptureMode = .photo
        self.present(picker, animated: true, completion: nil)
    }
    
    // Provide Image Library
    func provideGalleryForImagePicking(editting: Bool) {
        self.picker.allowsEditing = editting
        self.picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
