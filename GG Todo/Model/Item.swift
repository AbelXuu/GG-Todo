//
//  Item.swift
//  GG Todo
//
//  Created by Abel Xu on 11/10/18.
//  Copyright © 2018 Yupeng Xu. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
