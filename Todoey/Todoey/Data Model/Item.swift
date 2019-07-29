//
//  Item.swift
//  Todoey
//
//  Created by Tommi Rautava on 30/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Foundation
import CoreData

public class Item: NSManagedObject {
    public convenience init(context: NSManagedObjectContext, title: String, category: Category?) {
        self.init(context: context)
        self.title = title
        self.done = false
        self.parentCategory = category
    }

    public func toggleDone() {
        done = !done
    }
}
