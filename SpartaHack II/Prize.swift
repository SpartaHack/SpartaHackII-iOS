//
//  Prize.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/11/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation


class Prize: NSObject {
    var id: Int! = nil
    var name: String! = nil
    var sponsor: String! = nil
    var detail: String! = nil
    
    override init() {
        super.init()
    }
    
    override var debugDescription : String {
        let prize =
            "id: \(id!)" +
                "\n name:\(name!)" +
                "\n sponsor:\(sponsor!)" +
                "\n detail:\(detail!)"
        
        return prize
    }
}
