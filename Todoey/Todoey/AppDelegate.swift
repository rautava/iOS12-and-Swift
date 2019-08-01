//
//  AppDelegate.swift
//  Todoey
//
//  Created by Tommi Rautava on 29/07/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// [source](https://realm.io/docs/swift/latest/#migrations)
        let config = Realm.Configuration(
            schemaVersion: 2,

            migrationBlock: {
                migration, oldSchemaVersion in

                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: Item.className()) {
                        _, newObject in

                        newObject!["dateCreated"] = Date()
                    }
                } else if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: Category.className()) {
                        _, newObject in

                        newObject!["color"] = UIColor.randomFlat().hexValue()
                    }
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config

        do {
            _ = try Realm()
        } catch {
            print("Error while initializing Realm \(error)")
        }

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
