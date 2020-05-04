//
//  String+Extension.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit
extension String {

    var utfData: Data {
        return Data(utf8)
    }

    var attributedHtmlString: NSAttributedString? {

        do {
            return try NSAttributedString(data: utfData,
            options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue
                     ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}

extension UILabel {
   func setAttributedHtmlText(_ html: String) {
    if let attributedText = html.attributedHtmlString?.string {
        self.text = attributedText
      }
   }
}
