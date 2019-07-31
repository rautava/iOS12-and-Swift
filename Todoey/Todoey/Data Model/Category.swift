//
//  Category.swift
//  Todoey
//
//  Created by Tommi Rautava on 31/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Foundation
import RealmSwift

public class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
