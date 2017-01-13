//
//  DataVariety.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import CoreData

protocol CoreDataVarietyProtocol {
    associatedtype EntityType
    func get(with predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?,
             fetchLimit: Int?,
             completion: @escaping (Result<[EntityType]>) -> Void)
    func upsert(entities: [EntityType],
                completion: @escaping (Error?) -> Void)
}

extension CoreDataVarietyProtocol {
    func get(with predicate: NSPredicate? = nil,
             sortDescriptors: [NSSortDescriptor]? = nil,
             fetchLimit: Int? = nil,
             completion: @escaping (Result<[EntityType]>) -> Void){
        get(with: predicate,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            completion: completion)
    }
}

class DataVariety<ManagedEntity, Entity>: CoreDataVarietyProtocol where
    ManagedEntity: NSManagedObject,
    ManagedEntity: ManagedObjectProtocol,
    Entity: ManagedObjectConvertible {
    let coreData: CoreDataStackProtocol
    init(coreData: CoreDataStackProtocol = CoreDataStack.shared) {
        self.coreData = coreData
    }
    
    func get(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?,
             completion: @escaping (Result<[Entity]>) -> Void) {
        coreData.performForegroundTask { (context) in
            do {
                let fetchRequest = ManagedEntity.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                if let fetchLimit = fetchLimit {
                    fetchRequest.fetchLimit = fetchLimit
                }
                let results = try context.fetch(fetchRequest) as? [ManagedEntity]
                let items: [Entity] = results?.flatMap { $0.toEntity() as? Entity } ?? []
                completion(.success(items))
            } catch {
                let fetchError = CoreDataWorkerError.cannotFetch("Cannot fetch error: \(error))")
                completion(.failure(fetchError))
            }
        }
    }
    func upsert(entities: [Entity], completion: @escaping (Error?) -> Void) {
        coreData.performBackgroundTask { (context) in
            _ = entities.flatMap({ (entity) -> ManagedEntity? in
                return entity.toManagedObject(in: context) as? ManagedEntity
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



