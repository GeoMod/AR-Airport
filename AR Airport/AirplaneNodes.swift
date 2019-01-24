//
//  AirportNodes.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 12/14/18.
//  Copyright © 2018 Impulse Coupled Dev. All rights reserved.
//

import SceneKit

class AirplaneNode: SCNNode {
    
    override init() {
        super.init()
        
        // Main airplane scene
        guard let boeingScene = SCNScene(named: "art.scnassets/787.scn") else { return }
        
        // Nodes
        guard let airplaneNode = boeingScene.rootNode.childNode(withName: "787", recursively: true) else { return }
        
        addChildNode(airplaneNode)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

