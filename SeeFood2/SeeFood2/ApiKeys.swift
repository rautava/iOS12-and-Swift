//
//  ApiKeys.swift
//  SeeFood2
//
//  Created by Tommi Rautava on 07/08/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Foundation

/**
 Retrieve an API key from the property list.

 - Parameter name: The name of the requested API key.

 - Returns: The API key.
 */
public func getApiKey(name key: String) -> String? {
    var keys: NSDictionary?

    if let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") {
        keys = NSDictionary(contentsOfFile: path)
    }

    if let dict = keys {
        let value = dict[key] as? String
        return value;
    }

    return nil
}
