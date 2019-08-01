//
//  CoreManager.swift
//  LockBox701
//
//  Created by mac on 7/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreData

class CoreManager {
    
    
    static let shared = CoreManager()
    
    
    //MARK: CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LockBox701")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    //MARK: Save function called in ViewModel
    func saveMedia(data: Data, isVid: Bool) {
        let context = persistentContainer.viewContext
        
        let hash = String(data.hashValue)
        let path = isVid ? hash + ".mov" : hash
        
        let entity = NSEntityDescription.entity(forEntityName: "Content", in: context)!
        
        let coreContent = NSManagedObject(entity: entity, insertInto: context)
        
        print(path)
        coreContent.setValue(path, forKey: "path")
        coreContent.setValue(isVid, forKey: "isVideo")
        
        saveContext()
        
    }
    
    //MARK: Load function called in ViewModel
    func loadMedia() -> [Content] {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Content>(entityName: "Content")
        
        
        var content = [Content]()
   
        do {
            let coreContent = try context.fetch(fetchRequest)
            for cont in coreContent {
                content.append(cont)

            }
        } catch {
            print("Couldn't fetch media: \(error.localizedDescription)")
            return []
        }
        
        
        return content
    }
    
    
    //MARK: Future delete function ? Might work
    func deleteMedia(path: String, isVid: Bool, index: Int){
        let context = persistentContainer.viewContext
        
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(path) else {return}
        
        if !FileManager.default.fileExists(atPath: url.absoluteString.replacingOccurrences(of: "file://", with: "")){
//            print(url.absoluteString)
            print("No File Found")
            return
        }
        
        let fetchRequest = NSFetchRequest<Content>(entityName: "Content")
        let predicate = NSPredicate(format: "path==%@", path)
        
        fetchRequest.predicate = predicate
        var coreContent = [Content]()
        do {
            coreContent = try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch content: \(error.localizedDescription)")
        }
        //For testing duplicates
//        print(coreContent.count)
//        print(index-1)
        context.delete(coreContent.remove(at: (index-1)))
        if coreContent.count < 1 {
            print("here")
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        }
        saveContext()
    }
    
    
    //MARK: Helpers
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}
