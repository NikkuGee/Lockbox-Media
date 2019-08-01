//
//  ViewController+Extension.swift
//  LockBox701
//
//  Created by mac on 7/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func showAlert(with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func goToMedia() {
        let mediaNC = self.storyboard?.instantiateViewController(withIdentifier: "MediaNavController") as! UINavigationController
        self.present(mediaNC, animated: true, completion: nil)
    }
}
