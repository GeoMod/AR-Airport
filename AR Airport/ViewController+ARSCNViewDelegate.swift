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
            let restult = hitTest.last
            guard let transform = restult?.worldTransform  else { return }
            anchorTransform = transform
            let thirdColumn = transform.columns.3
            let position = SCNVector3Make(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            arrowPositions.append(position)
            // Average the last 10 positions of the arrow.
            let lastTenPositions = arrowPositions.suffix(10)
            arrow.position = getAveragePosition(from: lastTenPositions)
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if gameHasStarted {
            if airplane == nil{
                airplane = AirplaneNode()
                airplane?.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
                sceneView.scene.rootNode.addChildNode(airplane!)
                node.addChildNode(airplane!)
            }
        }
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        node.position = arrow.position
        //        node.childNode(withName: "787", recursively: true)
        //        node.eulerAngles = SCNVector3(180, 90, -10)
        
        //        let action = SCNAction.moveBy(x: controls.controlYoke.position.x, y: controls.controlYoke.position.y, z: 0, duration: 1.0)
        
    }
    
}
