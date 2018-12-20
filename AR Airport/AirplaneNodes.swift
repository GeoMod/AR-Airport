//
//  AirportNodes.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 12/14/18.
//  Copyright © 2018 Impulse Coupled Dev. All rights reserved.
//

import SceneKit

class AirplaneNodes: SCNNode {
    
    func addAircraft() {
        guard let piper = SCNScene(named: "art.scnassets/787.scn") else { return }
        let node = SCNNode()
        for airplane in piper.rootNode.childNodes {
            node.addChildNode(airplane)
        }
        addChildNode(node)
    }
}

