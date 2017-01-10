//
//  Acronym.swift
//  Macy
//
//  Created by Gansoronzon on 1/9/17.
//  Copyright © 2017 Optima Global Solution Inc. All rights reserved.
//

import UIKit

class Acronym: NSObject {
    var sf  : String
    var lfStrings = [String]()
    
    init(json: JSON) {
        self.sf         = json[0]["sf"].stringValue
        let lfs      = json[0]["lfs"].arrayValue
        for lf in lfs {
            self.lfStrings.append(lf["lf"].stringValue)
        }
    }
}
