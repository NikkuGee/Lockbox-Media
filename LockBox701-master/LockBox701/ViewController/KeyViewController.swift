//
//  ViewController.swift
//  LockBox701
//
//  Created by mac on 7/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import LocalAuthentication

class KeyViewController: UIViewController {

    
    @IBOutlet weak var keyCollectionView: UICollectionView!
    
    
    private let keypadNums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    private let keypadImgs = ["biometric", "done", "backspace"]
    
    private var selectedNums = "" {
        didSet {
            keyCollectionView.reloadData()
        }
    }
    
    var firstTimeUser: Bool {
        return UserDefaults.standard.value(forKey: "FirstTime") != nil ? false : true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKey()
    }
    
    
    
    private func setupKey() {
        
        keyCollectionView.register(UINib(nibName: KeyCollectionHeader.identifier, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: KeyCollectionHeader.identifier)
        
        if firstTimeUser {
            DispatchQueue.main.async {
                self.showAlert(with: "Create Passcode", message: "Set up pass code for LockBox")
            }
        }
        
    }

    
    //MARK: Biometrics - Authenticate
    
    private func aunthenticate() {
        
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return
        }
        
        let reason = "Authenticate to unlock the app"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, err) in
            if let _ = err {
                return
            }
            
            if success {
                
                DispatchQueue.main.async {
                   self.goToMedia()
                }
            }
        }
    }


}

extension KeyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? keypadNums.count : keypadImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCollectionCellOne.identifier, for: indexPath) as! KeyCollectionCellOne
            
            let number = keypadNums[indexPath.row]
            cell.number = number
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCollectionCellTwo.identifier, for: indexPath) as! KeyCollectionCellTwo
            
            let img = keypadImgs[indexPath.row]
            cell.image = img
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KeyCollectionHeader.identifier, for: indexPath) as! KeyCollectionHeader
        
        let asteriks = String(repeating: "*", count: selectedNums.count)
        cell.asteriks = asteriks
        
        return cell
    }
    
    
}

extension KeyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size.width / 4.2
        return .init(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: view.frame.width, height: 200) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let firstSectionInsets = UIEdgeInsets(top: 0, left: 35, bottom: 10, right: 35)
        let secondSectionInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
       
        return section == 0 ? firstSectionInsets : secondSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            
            guard selectedNums.count < 4 else {
                return
            }
            
            let number = keypadNums[indexPath.row]
            selectedNums.append(number)
        default:
            switch indexPath.row {
            case 0:
                self.aunthenticate()
            case 1:
                
                if firstTimeUser {
                    guard selectedNums.count == 4 else {
                        self.showAlert(with: "Not Enough Numbers", message: "Your passcode was too short")
                        return
                    }
                    KeychainManager(account: "user").saveKeychain(with: selectedNums)
                    UserDefaults.standard.set(true, forKey: "FirstTime")
                    
                    let alert = UIAlertController(title: "Success", message: "New passcode has been created for LockBox", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .cancel) { [weak self] _  in
                        self?.goToMedia()
                    }
                    
                    alert.addAction(okayAction)
                    present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    if KeychainManager(account: "user").isValid(selectedNums) {
                        self.goToMedia()
                    } else {
                        self.showAlert(with: "Incorrect Passcode", message: "Your passcode was invalid")
                    }
                    
                }
            default:
                guard !selectedNums.isEmpty else {
                    return
                }
                selectedNums.removeLast()
            }
           
        }
    }
    
    
}
