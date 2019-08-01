//
//  KeyCollectionCellOne.swift
//  LockBox701
//
//  Created by mac on 7/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyCollectionCellOne: UICollectionViewCell {
    
    var number: String? {
        didSet {
            keyCellLabel.text = number
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : .collectionCellGray
            keyCellLabel.textColor = isHighlighted ? .white : .darkGray
        }
    }
    
    
    
    @IBOutlet weak var keyCellLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.collectionCellGray
        layer.cornerRadius = layer.frame.height / 2
    }
    
    static let identifier = "KeyCollectionCellOne"
    
}
