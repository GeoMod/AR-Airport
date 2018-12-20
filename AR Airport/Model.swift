//
//  Model.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 12/14/18.
//  Copyright © 2018 Impulse Coupled Dev. All rights reserved.
//

import SceneKit



func getAveragePosition(from positions: ArraySlice<SCNVector3>) -> SCNVector3 {
    var averageX = Float()
    var averageY = Float()
    var averageZ = Float()
    
    for position in positions {
        averageX += position.x
        averageY += position.y
        averageZ += position.z
    }
    
    // The number of all positions given.
    let count = Float(positions.count)
    
    // Send this for the position of the pointer arrow. Averaged from the last 10 given positons for smoother indications.
    return SCNVector3Make(averageX/count, averageY/count, averageZ/count)
}
