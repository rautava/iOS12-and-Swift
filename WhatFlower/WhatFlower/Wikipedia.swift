//
//  Wikipedia.swift
//  WhatFlower
//
//  Created by Tommi Rautava on 12/08/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

fileprivate let wikipediaURl = "https://en.wikipedia.org/w/api.php"

class Wikipedia {
    typealias fetchArticleCompletionHandler = (_ description: String?, _ imageUrl: String?) -> Void

    static func fetchArticle(query: String, completionHandler: @escaping fetchArticleCompletionHandler) {
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : query,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500"
        ]

        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (dataResponse) in
            if dataResponse.result.isSuccess {
                if let data = dataResponse.result.value {
                    let json = JSON(data)
                    let pageId = json["query"]["pageids"][0].stringValue
                    let description = json["query"]["pages"][pageId]["extract"].stringValue
                    let imageUrl = json["query"]["pages"][pageId]["thumbnail"]["source"].stringValue

                    completionHandler(description, imageUrl)
                }
            }
        }

        completionHandler(nil, nil)
    }
}
