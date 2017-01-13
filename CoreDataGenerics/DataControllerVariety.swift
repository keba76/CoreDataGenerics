//
//  DataControllerVariety.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import Foundation

class DataControllerVariety: DataControllerProtocol {
    
    let data: DataVariety<UserData, User>
    private var currentUser: User?
    
    init(data: DataVariety<UserData, User> = DataVariety<UserData, User>()) {
        self.data = data
    }
    func fetchUser(completion: @escaping (User?) -> Void) {
        data.get{ [weak self](result: Result<[User]>) in
            switch result {
            case .success(let users):
                self?.currentUser = users.first
                completion(users.first)
            case .failure(let error):
                print("\(error)")
                completion(nil)
            }
        }
    }
    
    func updateUser(name: String?, username: String?){
        var user: User = currentUser ?? User(id: UUID().uuidString)
        user.name = name
        user.username = username
        data.upsert(entities: [user]){ (error) in
            guard let error = error else { return }
            print("\(error)")
        }
    }
}
