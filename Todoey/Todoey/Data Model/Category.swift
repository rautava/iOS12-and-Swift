//
//  Category.swift
//  Todoey
//
//  Created by Tommi Rautava on 31/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import ChameleonFramework
import Foundation
import RealmSwift

public class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = UIColor.randomFlat().hexValue()
    let items = List<Item>()
}
