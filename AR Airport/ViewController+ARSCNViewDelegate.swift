//
//  ViewController+ARSCNViewDelegate.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 1/22/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import ARKit


extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if !gameHasStarted {
            let hitTest = sceneView.hitTest(center, types: .existingPlaneUsingExtent)
            guard let restult = hitTest.last else { return }
            anchorTransform = restult.worldTransform
            let thirdColumn = anchorTransform.columns.3
            let position = SCNVector3Make(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            arrowPositions.append(position)
            // Average the last 10 positions of the arrow.
            let lastTenPositions = arrowPositions.suffix(10)
            arrow.position = getAveragePosition(from: lastTenPositions)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if anchor == airplaneAnchor {
            airplane = AirplaneNode()
            node.addChildNode(airplane!)
            node.position = SCNVector3(x: arrow.position.x, y: arrow.position.y, z: arrow.position.z)
        }
        return node
    }
    
    

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let airplaneNode = node.childNode(withName: "787", recursively: true) else { return }
        airplaneNode.eulerAngles.z = Float(touchDegrees) / 10
        
        print("TouchDeg = \(touchDegrees)")
    }

    
}
