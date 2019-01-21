//
//  Categories.swift
//  todoey
//
//  Created by Deepak Balaji on 1/21/19.
//  Copyright © 2019 Deepak Balaji. All rights reserved.
//

import Foundation
import RealmSwift

class Categories : Object {
    @objc dynamic var name : String = ""
    let items = List<Items>()
    
}
