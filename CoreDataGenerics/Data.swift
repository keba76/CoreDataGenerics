//
//  Data.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import Foundation

protocol CoreDataProtocol {
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate?,
         sortDescriptors: [NSSortDescriptor]?,
         fetchLimit: Int?,
         completion: @escaping (Result<[Entity]>) -> Void)
    func upsert<Entity: ManagedObjectConvertible>
        (entities: [Entity],
         completion: @escaping (Error?) -> Void)
}
extension CoreDataProtocol {
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate? = nil,
         sortDescriptors: [NSSortDescriptor]? = nil,
         fetchLimit: Int? = nil,
         completion: @escaping (Result<[Entity]>) -> Void) {
        get(with: predicate,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            completion: completion)
    }
}

enum CoreDataWorkerError: Error{
    case cannotFetch(String)
    case cannotSave(Error)
}

class Data: CoreDataProtocol {
    let coreData: CoreDataStackProtocol
    init(coreData: CoreDataStackProtocol = CoreDataStack.shared) {
        self.coreData = coreData
    }
    
    func get<Entity : ManagedObjectConvertible>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: @escaping (Result<[Entity]>) -> Void) {
        coreData.performForegroundTask { (context) in
            do {
                let fetchRequest = Entity.ManagedObject.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                if let fetchLimit = fetchLimit {
                    fetchRequest.fetchLimit = fetchLimit
                }
                let results = try context.fetch(fetchRequest) as? [Entity.ManagedObject]
                let items: [Entity] = results?.flatMap { $0.toEntity() as? Entity } ?? []
                completion(.success(items))
            } catch {
                let fetchError = CoreDataWorkerError.cannotFetch("Cannot fetch error: \(error))")
                completion(.failure(fetchError))
            }
        }
    }
    
    func upsert<Entity: ManagedObjectConvertible>(entities: [Entity], completion: @escaping (Error?) -> Void) {        
        coreData.performBackgroundTask { context in
            _ = entities.flatMap({ (entity) -> Entity.ManagedObject? in
                return entity.toManagedObject(in: context)
            })
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(CoreDataWorkerError.cannotSave(error))
            }
        }
    }
    
}
