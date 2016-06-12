//
//  RandomFunction.swift
//  Homework3D
//
//  Created by Hoang Minh Tuan Vu on 6/4/16.
//  Copyright © 2016 Tuan Vu. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min min:CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
    
}