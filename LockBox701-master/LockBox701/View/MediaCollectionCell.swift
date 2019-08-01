//
//  MediaCollectionCell.swift
//  LockBox701
//
//  Created by mac on 7/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MediaCollectionCell: UICollectionViewCell {
    
    var content: Content? {
        didSet {
            switch content!.isVideo {
            case true:
                break
            case false:
                guard let url = FileService().load(from: content!.path!) else { return }
                mediaImage.image = UIImage(contentsOfFile: url.path)
            }
        }
    }
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    static let identifier = "MediaCollectionCell"
    
    
    
}
