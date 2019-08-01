//
//  FileManager.swift
//  LockBox701
//
//  Created by mac on 7/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct FileService {
    
    
    func save(_ data: Data, isVideo: Bool) {
        
        let hash = String(data.hashValue)
        let path = isVideo ? hash + ".mov" : hash
        
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(path) else {return}
        
        
        do {
            try data.write(to: url)
            print("Saved Data to Disk")
        }catch {
            fatalError()
        }
    }
    
    
    func load(from path: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomain = FileManager.SearchPathDomainMask.userDomainMask
        
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomain, true)
        
        guard let directoryPath = paths.first else {return nil}
        
        return URL(fileURLWithPath: directoryPath).appendingPathComponent(path)
        
    }
    
    func delete(url: URL) {
        
        
    }
}
