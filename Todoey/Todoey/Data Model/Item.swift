//
//  Item.swift
//  Todoey
//
//  Created by Tommi Rautava on 30/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Foundation
import RealmSwift

public class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

    public func toggleDone() {
        done = !done
    }
}
