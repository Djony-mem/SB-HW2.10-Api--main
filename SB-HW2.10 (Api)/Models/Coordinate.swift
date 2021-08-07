//
//  Coordinate.swift
//  SB-HW2.10 (Api)
//
//  Created by Vladislav Kulak on 06.08.2021.
//

import Foundation

class Coordinate {
    static var shared = Coordinate()
    
    var longtitude = 0.0
    var latitude = 0.0
    var icon = ""
    
    private init(){}
}



