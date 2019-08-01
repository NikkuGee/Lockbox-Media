//
//  KeychainManager.swift
//  LockBox701
//
//  Created by mac on 7/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Security


struct KeychainManager {
    
    
    
    /*
     In order to save to Keychain you must have a Keychain Item (CFDictionary). Item's have three attributes: Service Name (App Name), Account Name (individual name of the item), Access Group (allows you to share the keychain across multiple apps)
    */
    
    
    
    let service = "LockBox701"
    private(set) var account: String //getter is only accessible
    

    
    init(account: String) {
        self.account = account
    }
    
    func saveKeychain(with password: String) {
        
        var item = createKeychainItem()
        
        let encoded = password.data(using: .utf8)
        
        item[kSecValueData as String] = encoded as AnyObject?
        
        SecItemAdd(item as CFDictionary, nil)
        
        print("Saved Passcode to Keychain")
        
    }
    
    func isValid(_ pass: String) -> Bool {
        
        var item = createKeychainItem()
        
        item[kSecReturnAttributes as String] = kCFBooleanTrue //true, meaning unencypted
        
        item[kSecReturnData as String] = kCFBooleanTrue //true, meaning password will be data type
        
        
        var result: AnyObject?
        
        SecItemCopyMatching(item as CFDictionary, &result)
        
        var retrievedPasword: String?
        
        if let existingItem = result as? [String:AnyObject],
            let encoded = existingItem[kSecValueData as String] as? Data {
            retrievedPasword = String(data: encoded, encoding: .utf8)
        }
        
        if retrievedPasword != nil && retrievedPasword == pass {
            return true
        }
        
        return false
    }
    
    
    //MARK: Helper
    
    private func createKeychainItem() -> [String : AnyObject] {
        
        
        var item = [String:AnyObject]()
        
        item[kSecClass as String] = kSecClassGenericPassword
        
        item[kSecAttrAccount as String] = account as AnyObject?
        
        item[kSecAttrService as String] = service as AnyObject?
        
        
        return item
    }
    
    
    
}
