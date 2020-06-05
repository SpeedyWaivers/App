//
//  RegistrationVC.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/10/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import StepIndicator
import WebKit

typealias CustomerValidateItem = (name: String, required: Bool, displayName: String, value: String)

class RegistrationVC: BaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {didSet{
        tableView.rx.setDelegate(self).disposed(by: bag)
        }}
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var viewStep: StepIndicatorView!
    @IBOutlet weak var signingView: UIView!
    @IBOutlet weak var checkView: UICheckbox!
    @IBOutlet var signingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var agreementWebView: WKWebView!
    
    
    // MARK: - Variable
    let bag = DisposeBag()
    let vm = RegistrationVM()
    var allPages = 0
    var numberOfFieldsPerPage: Int = 0
    var page: Int = 0
    let defaultCellIdentifire = "DefaultTVCell"
    let dobCellIdentifire = "DobTVCell"
    var customerValidateData = [(name: String, required: Bool, displayName: String, value: String)]()
    var currentValidatingCustomerData = [(name: String, required: Bool, displayName: String, value: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        proceedWithGetVenuesAndRegistrationData()
        setupUI()
        addObservers()
    }
    
    func setupUI() {
        [nextButton, backButton].forEach { (btn) in
            btn?.addLayerEffects(with: .lightGray, borderWidth: 1, cornerRadius: 4)
        }
        
        viewStep.numberOfSteps = allPages
        viewStep.currentStep = page
        signingView.isHidden = true
        view.bringSubviewToFront(tableView)
        
        signatureView.layer.borderColor = UIColor.lightGray.cgColor
        signatureView.layer.masksToBounds = true
        signatureView.layer.borderWidth = 2
        signatureView.layer.cornerRadius = 8
        
        if page == 0 {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
    }
    
    func addObservers() {
        
        backButton.rx.tap
            .subscribe()  {[weak self] event in
                self?.pressedBackButton()
        }
        .disposed(by: bag)
        
        nextButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedNextButton()
        }
        .disposed(by: bag)
        
        vm.registrationArray.asObservable()
            .bind(to: tableView.rx.items) { tableView, row, model in
                let indexpath = IndexPath(row: row, section: 0)
                
                if model.name == "BirthDate" {
                    tableView.register(UINib(nibName: self.dobCellIdentifire, bundle: nil), forCellReuseIdentifier: self.dobCellIdentifire)
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.dobCellIdentifire, for: indexpath) as! DobTVCell
                    cell.configureCell(with: model, customerItem: self.customerValidateData.filter{$0.name == model.name}.first)
                    cell.delegate = self
                    return cell
                } else {
                    tableView.register(UINib(nibName: self.defaultCellIdentifire, bundle: nil), forCellReuseIdentifier: self.defaultCellIdentifire)
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifire, for: indexpath) as! DefaultTVCell
                    cell.configureCell(with: model, customerItem: self.customerValidateData.filter{$0.name == model.name}.first)
                    cell.delegate = self
                    print("CUSTTTT \(self.customerValidateData)")
                    return cell
                }
        }
        .disposed(by: bag)
        
        vm.weiverText.asDriver().drive ( onNext: { [weak self] text in
            print("AGREEEMENT \(text)")
            self?.agreementWebView.loadHTMLString(text, baseURL: nil)
        }).disposed(by: bag)
    }
    
    func pressedBackButton() {
        if page != 0 {
            page -= 1
            viewStep.currentStep = page
            if page == 0 {
                backButton.isHidden = true
            }
            
            nextButton.setTitle( page == allPages - 1 ? "Finish" : "Next", for: .normal)
            showSignViewIfNeeded(show: page == allPages - 1 ? true : false)
            let fieldsArr = self.vm.registrationFields.value.filter({$0.page == self.page}).first
            geneateCustomerData(data: fieldsArr?.registrationFields ?? [])
            self.setCurrentValidateData(fields: fieldsArr?.registrationFields ?? [])
            self.vm.registrationArray.accept(fieldsArr?.registrationFields ?? [])
        }
    }
    
    func showSignViewIfNeeded(show: Bool) {
        if show {
            signingView.isHidden = false
            signingView.isUserInteractionEnabled = true
            view.bringSubviewToFront(signingView)
        } else {
            signingView.isHidden = true
            signingView.isUserInteractionEnabled = false
            view.bringSubviewToFront(tableView)
        }
    }
    
    func pressedNextButton() {
        
        if validateCustomerData() {
            
            if page == allPages - 1 {
                validateSignaturePage()
            } else {
                page += 1
                viewStep.currentStep = page
                
                if page != 0 {
                    backButton.isHidden = false
                }
                nextButton.setTitle( page == allPages - 1 ? "Finish" : "Next", for: .normal)
                
                showSignViewIfNeeded(show: page == allPages - 1 ? true : false)
                
                
                let fieldsArr = self.vm.registrationFields.value.filter({$0.page == self.page}).first
                geneateCustomerData(data: fieldsArr?.registrationFields ?? [])
                self.setCurrentValidateData(fields: fieldsArr?.registrationFields ?? [])
                self.vm.registrationArray.accept(fieldsArr?.registrationFields ?? [])
            }
        }
    }
    
    func geneateCustomerData(data: [RegistrationSettingNoId]) {
        data.forEach { dataItem in
            if customerValidateData.filter({($0.name ) == (dataItem.name ?? "")}).count > 0 {
                //No need to add, already there
            } else {
                let customerItem = CustomerValidateItem(name: dataItem.name ?? "", required: dataItem._required , displayName: dataItem.displayName ?? "", value: "")
                customerValidateData.append(customerItem)
            }
        }
    }
    
    func validateCustomerData() -> Bool {
        if let nonValidateItem = currentValidatingCustomerData.filter{$0.required == true && $0.value == ""}.first {
            AlertProvider(vc: self).showAlert(title: "Alert", message: "\(nonValidateItem.displayName) is required for the form.", action: AlertAction(title: "Ok"))
            return false
        } else {
            return true
        }
    }
    
    func validateSignaturePage() {
        if signatureView.doesContainSignature {
            
            if checkView.isSelected {
                handleCustomerRegistration()
            } else {
                 AlertProvider(vc: self).showAlert(title: "Alert", message: "Please accept the agreement.", action: AlertAction(title: "Ok"))
            }
        } else {
            AlertProvider(vc: self).showAlert(title: "Alert", message: "Please put a signature.", action: AlertAction(title: "Ok"))
        }
    }
    
    func handleCustomerRegistration() {
        let availableValues = customerValidateData.filter{$0.value != ""}
        var fieldParamsArray: [String: Any] = ["venueId" : vm.venues.value.first?.venueId ?? 0]
            
        _ = availableValues.compactMap{ fieldParamsArray[$0.name] = $0.value}
        
        if let signImage = signatureView.getSignature() {
            fieldParamsArray["signature"] = "data:image/png;base64,\(signImage.toBase64() ?? "")"
        }
        
        startLoading()
        vm.customerCreateNetworkRequest(params: fieldParamsArray) { (success, _, message) in
            self.stopLoading()
            if success {
                print("Save Success")
                ApplicationService.shared.manageUserDirection()
            } else {
                AlertProvider(vc: self).showAlert(title: "Alert", message: message, action: AlertAction(title: "Ok"))
            }
        }
        
        print("FIELDVA \(fieldParamsArray)")
    }
    
    func setCurrentValidateData(fields: [RegistrationSettingNoId]) {
        var customeItems = [CustomerValidateItem]()
        
        fields.forEach { dataItem in
            let customerItem = CustomerValidateItem(name: dataItem.name ?? "", required: dataItem._required , displayName: dataItem.displayName ?? "", value: customerValidateData.filter{$0.name == dataItem.name}.first?.value ?? "")
            customeItems.append(customerItem)
        }
        
        currentValidatingCustomerData = customeItems
    }
    
    
    // ---------------- network request  ------------------
    
    func proceedWithGetVenuesAndRegistrationData() {
        startLoading()
        vm.getVenuesNetworkRequest { (success, statusCode, message) in
            if success {
                // no action here
                self.vm.getRegistrationDetailsNetworkRequest { (success, statusCode, message) in
                    self.stopLoading()
                    if success {
                        let fieldsArr = self.vm.registrationFields.value.filter({$0.page == self.page}).first
                        self.geneateCustomerData(data: fieldsArr?.registrationFields ?? [])
                        self.setCurrentValidateData(fields: fieldsArr?.registrationFields ?? [])
                        self.vm.registrationArray.accept(fieldsArr?.registrationFields ?? [])
                        
                        //generate customer data
                        
                        
                        self.allPages = self.vm.registrationFields.value.compactMap{$0.page}.count + 1
                        self.viewStep.numberOfSteps = self.allPages
                        

                    } else {
                        if statusCode > 400 && statusCode < 501 {
                            UserDefaults.standard.removeObject(forKey: "x-access-token")
                            ApplicationService.shared.manageUserDirection()
                        } else {
                            AlertProvider(vc: self).showAlert(title: .Error, message: message, action: .init(title: .Dismiss))
                        }
                    }
                }
                
            } else {
                self.stopLoading()
                if statusCode > 400 && statusCode < 501 {
                    UserDefaults.standard.removeObject(forKey: "x-access-token")
                    ApplicationService.shared.manageUserDirection()
                } else {
                    AlertProvider(vc: self).showAlert(title: .Error, message: message, action: .init(title: .Dismiss))
                }
            }
        }
    }
    
}
extension RegistrationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension RegistrationVC: DefaultCellValueChanged {
    func cellValueChangedWith(item: CustomerValidateItem?) {
        if let changedItem = item {
            let filteredValue = customerValidateData.filter{$0.name != changedItem.name}
            customerValidateData = filteredValue
            customerValidateData.append(changedItem)
            print("CUUUUU \(customerValidateData)")
            
            //handle current custom fields value
            if currentValidatingCustomerData.filter({$0.name == changedItem.name}).count > 0 {
                //items available
                let filteredCurrentValue = currentValidatingCustomerData.filter{$0.name != changedItem.name}
                currentValidatingCustomerData = filteredCurrentValue
                currentValidatingCustomerData.append(changedItem)
                
            }
        }
    }
}

extension RegistrationVC: DOBCellValueChanged {
    func cellDOBValueChangedWith(item: CustomerValidateItem?) {
        if let changedItem = item {
            let filteredValue = customerValidateData.filter{$0.name != changedItem.name}
            customerValidateData = filteredValue
            customerValidateData.append(changedItem)
            print("DUUUUU \(customerValidateData)")
            
            //handle current custom fileds value
            if currentValidatingCustomerData.filter({$0.name == changedItem.name}).count > 0 {
                //items available
                let filteredCurrentValue = currentValidatingCustomerData.filter{$0.name != changedItem.name}
                currentValidatingCustomerData = filteredCurrentValue
                currentValidatingCustomerData.append(changedItem)
                
            }
        }
    }
}
