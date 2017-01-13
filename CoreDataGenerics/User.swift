//
//  User.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import Foundation
import CoreData

struct User {
    let id: String
    var name: String?
    var username: String?
}
extension User {
    init(id: String) {
        self.id = id
        self.name = nil
        self.username = nil
    }
}
extension User: ManagedObjectConvertible {
    func toManagedObject(in context: NSManagedObjectContext) -> UserData? {
        let user = UserData.getOrCreateSingle(with: id, from: context)
        user.name = name
        user.username = username
        return user
    }
}
