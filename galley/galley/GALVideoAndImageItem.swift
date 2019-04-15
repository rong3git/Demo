//
//  GALVideoAndImageItem.swift
//  galley
//
//  Created by rongc on 6/23/18.
//  Copyright © 2018 RongchangLei. All rights reserved.
//

import UIKit
import Foundation

class GALVideoAndImageItem: NSObject {
    public var imageURL = ""
    public var videoURL = ""
    
    public init(dictionary: [String:Any]) {
        if dictionary["imageUrl"] != nil {
            self.imageURL = (dictionary["imageUrl"] as? String)!
        }
        if dictionary["videoUrl"] != nil {
            self.videoURL = (dictionary["videoUrl"] as? String)!
        }
    }
}
