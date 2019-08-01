//
//  KeyCollectionCellTwo.swift
//  LockBox701
//
//  Created by mac on 7/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyCollectionCellTwo: UICollectionViewCell {
    
    var image: String? {
        didSet {
            keyCellImage.image = UIImage(named: image!)
        }
    }
    
    @IBOutlet weak var keyCellImage: UIImageView!
    
    static let identifier = "KeyCollectionCellTwo"
    
}
