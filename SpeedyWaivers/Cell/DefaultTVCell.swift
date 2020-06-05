//
//  DefaultTVCell.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/31/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol DefaultCellValueChanged {
    func cellValueChangedWith(item: CustomerValidateItem?)
}

class DefaultTVCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var textTF: UITextField!
    
    
    // MARK: Variables
    
    var bag = DisposeBag()
    var currentCustomerItem: CustomerValidateItem?
    var delegate: DefaultCellValueChanged?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addObsevers()
        backView.addLayerEffects(with: .lightGray, borderWidth: 1, cornerRadius: 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
        addObsevers()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addObsevers() {
        textTF.rx.text.orEmpty.subscribe(onNext: { [weak self] txt in
             // do something
            self?.currentCustomerItem?.value = txt
            self?.delegate?.cellValueChangedWith(item: self?.currentCustomerItem)
        }).disposed(by: bag)
    }
    
    func configureCell(with model: RegistrationSettingNoId, customerItem: CustomerValidateItem? ) {
        if model.name == "MobileNumber" {
            textTF.keyboardType = .phonePad
        } else {
            textTF.keyboardType = .default
        }
        titleLabel.text = model.displayName
        textTF.text = customerItem?.value
        currentCustomerItem = customerItem
    }
}
