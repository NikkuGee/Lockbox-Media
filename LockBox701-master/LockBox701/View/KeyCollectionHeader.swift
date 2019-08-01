//
//  KeyCollectionHeader.swift
//  LockBox701
//
//  Created by mac on 7/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyCollectionHeader: UICollectionViewCell {
    
    var asteriks: String? {
        didSet {
            keyHeaderLabel.text = asteriks
        }
    }
    
    @IBOutlet weak var keyHeaderLabel: UILabel!
    
    static let identifier = "KeyCollectionHeader"
    
    
}
