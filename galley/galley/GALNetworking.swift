//
//  GALNetworking.swift
//  galley
//
//  Created by rongc on 6/24/18.
//  Copyright © 2018 RongchangLei. All rights reserved.
//

import UIKit

typealias queryResult = ([GALVideoAndImageItem]) -> ()

class GALNetworking: NSObject {
    let baseURL = "http://private-04a55-videoplayer1.apiary-mock.com/pictures"
    func fetchNetworkData(_ completionBlock: @escaping queryResult) {
        if let url = URL(string: baseURL) {
            let task: URLSessionDataTask? = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                var items = [GALVideoAndImageItem]()
                let array = try? JSONSerialization.jsonObject(with: data!, options: []) as? [Any]
                if let resultArray = array {
                    for item in resultArray! {
                        items.append(GALVideoAndImageItem(dictionary: item as! [String : Any]))
                    }
                    completionBlock(items)
                }
            })
            task?.resume()
        }
    }
}
