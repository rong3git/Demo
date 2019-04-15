//
//  UIImage+Sizing.swift
//  galley
//
//  Created by rongc on 6/23/18.
//  Copyright © 2018 RongchangLei. All rights reserved.
//

import UIKit

extension UIImage {
    class func resizingImage(_ image: UIImage?, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
