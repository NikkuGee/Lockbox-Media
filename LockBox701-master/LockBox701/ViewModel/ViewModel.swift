//
//  ViewModel.swift
//  LockBox701
//
//  Created by mac on 7/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation



final class ViewModel {
    
    var content = [Content](){
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Reload"), object: nil)
        }
    }
    
    var index: Int?
    var currentContent: Content?
    
    
    func load(){
        content = CoreManager.shared.loadMedia()
    }
    
    func delete(path: String, isVid: Bool, index: Int){
        
        //Determine which duplicate if any is deleted
        var i = 0
        for con in content {
            if i > index {
                break
            }
            if con.path == path {
                i+=1
            }
        }
        CoreManager.shared.deleteMedia(path: path, isVid: isVid, index: i)
        content.remove(at: index)
        self.load()
    }
    
    func save(data: Data, isVid: Bool){
        CoreManager.shared.saveMedia(data: data, isVid: isVid)
        self.load()
    }
}
