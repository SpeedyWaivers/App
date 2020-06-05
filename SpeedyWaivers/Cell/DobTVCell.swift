//
//  DobTVCell.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/31/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DOBCellValueChanged {
    func cellDOBValueChangedWith(item: CustomerValidateItem?)
}

class DobTVCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var textTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    // MARK: Variables
    var bag = DisposeBag()
    let datePicker = UIDatePicker()
    var formatter: DateFormatter = {
        let dF = DateFormatter()
        dF.dateFormat = "dd/MM/yyyy"
        return dF
    }()
    var currentCustomerItem: CustomerValidateItem?
    var delegate: DOBCellValueChanged?
    var datePickerActive: Bool = false
    var tap: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.addLayerEffects(with: .lightGray, borderWidth: 1, cornerRadius: 2)
        setupDatePicker()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(with model: RegistrationSettingNoId, customerItem: CustomerValidateItem?) {
        titleLabel.text = model.displayName
        currentCustomerItem = customerItem
        
        //if item available
        if let item = customerItem {
            if item.value != "" {
                if let date = formatter.date(from: item.value) {
                    textTF.text = formatter.string(from: date)
                }
            }
        }
    }
    private func setupDatePicker() {
        
        datePickerActive = true
        
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        textTF.inputAccessoryView = toolbar
        textTF.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        textTF.text = formatter.string(from: datePicker.date)
        
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        currentCustomerItem?.value = apiFormatter.string(from: datePicker.date)
        delegate?.cellDOBValueChangedWith(item: currentCustomerItem)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
        datePickerActive = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
}
