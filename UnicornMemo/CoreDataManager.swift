//
//  CoreDataManager.swift
//  UnicornMemo
//
//  Created by Eddie Ahn on 2020/04/27.
//  Copyright © 2020 Sang Wook Ahn. All rights reserved.
//

import Foundation
import CoreData

extension NSNotification.Name{
    static let memoDidDelete = NSNotification.Name(rawValue: "MemoDidDelete")
}

class CoreDataManager {
    var list = [MemoEntity]()
    static let shared = CoreDataManager()
    private init() { }
    var modelName: String?
    func setup(modelName: String) {
        self.modelName = modelName
        CoreDataManager.shared.fetchMemo()
    }
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    func createMemo(content: String?) {
        var positionStart: Int32 = 0
        if let content = content {
            let newEntity = MemoEntity(context: context)
            newEntity.content = content
            newEntity.date = Date()
            newEntity.positionInTable = positionStart
            list.insert(newEntity, at: 0)
            for item in list {
                item.positionInTable = positionStart
                positionStart += 1
            }
            saveContext()
        }
    }
    func fetchMemo() {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "positionInTable", ascending: true)
        request.sortDescriptors = [sortDescriptors]
        do {
            let result = try context.fetch(request)
            list = result
        } catch {
            list.removeAll()
            print(error)
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = { [weak self] in
        let container = NSPersistentContainer(name: self?.modelName ?? "")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        }()
    
    // MARK: - Core Data Saving support
    
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
    func deleteMemo(entity: MemoEntity){
        // find index of memoentity in list array.
        if let index = list.firstIndex(of: entity) {
            // remove entity from list array using index.
            list.remove(at: index)
            // delete from context and save.
            context.delete(entity)
            saveContext()
            // use NotificationCenter to post UserInfo: ["Index" : index]
            NotificationCenter.default.post(name: .memoDidDelete, object: nil)
        }
        
    }
    
    
    
}

