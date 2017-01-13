//
//  UserData+CoreDataClass.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import Foundation
import CoreData


public class UserData: NSManagedObject {}

extension UserData: ManagedObjectProtocol {
    func toEntity() -> User? {
        return User(id: identifier, name: name, username: username)
    }
}

