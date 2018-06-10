//
//  publicExtension.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    public func AttributesOutLine(font : UIFont , title : String , strokeWidth : Double) {
        let strokeTextAttributes: [NSAttributedStringKey: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.white, .strokeWidth : strokeWidth , .strikethroughColor : UIColor.white , .font: font]
        self.attributedText = NSMutableAttributedString(string: title , attributes: strokeTextAttributes)
    }
}

