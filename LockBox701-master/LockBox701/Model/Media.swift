//
//  Media.swift
//  LockBox701
//
//  Created by Consultant on 8/1/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


class Media {
    var isVideo: Bool
    var url: String
    
    
    init(urlString: String, videoBool: Bool){
        isVideo = videoBool
        url = urlString
    }
    
    init(from core: Content) {
        url = core.value(forKey: "path") as! String
        isVideo = core.value(forKey: "isVideo") as! Bool
    }
    
}
