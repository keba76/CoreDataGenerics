//
//  ManagedObjectProtocol.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import CoreData

protocol ManagedObjectProtocol {
    associatedtype EntityData
    func toEntity() -> EntityData?
}

extension ManagedObjectProtocol where Self: NSManagedObject {
    
    static func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> Self {
        let result = single(with: id, from: context) ?? insertNew(in: context)
        result.setValue(id, forKey: "identifier")
        return result
    }
    
    static func single(with id: String, from context: NSManagedObjectContext) -> Self? {
        let predicate = NSPredicate(format: "identifier == %@", id)
        return single(from: context, with: predicate, sortDescriptors: nil)
    }
    
    static func single(from context: NSManagedObjectContext, with predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?) -> Self? {
        return fetch(from: context, with: predicate, sortDescriptors: sortDescriptors, fetchLimit: 1)?.first
    }
    
    static func insertNew(in context: NSManagedObjectContext) -> Self {
        return Self(context:context)
    }
    
    static func fetch(from context: NSManagedObjectContext, with predicate: NSPredicate?,
                      sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?) -> [Self]? {
        
        let fetchRequest = Self.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        var result: [Self]?
        // func getOrCreateSingle at this moment working in asynchronously. Therefore performAndWait in synchronously.
        context.performAndWait { () -> Void in
            do {
                result = try context.fetch(fetchRequest) as? [Self]
            } catch {
                result = nil
                //Report Error
                print("CoreData fetch error \(error)")
            }
        }
        return result
    }
}
