//
//  Result.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import Foundation
enum Result<T>{
    case success(T)
    case failure(Error)
}
