//
//  Category.swift
//  GG Todo
//
//  Created by Abel Xu on 11/10/18.
//  Copyright © 2018 Yupeng Xu. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
