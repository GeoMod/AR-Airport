//
//  ViewController.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 12/14/18.
//  Copyright © 2018 Impulse Coupled Dev. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var center: CGPoint!
    let arrow = SCNScene(named: "art.scnassets/rings.scn")!.rootNode
    let airportScene = SCNScene(named: "art.scnassets/runway.scn")!.rootNode
    var arrowPositions = [SCNVector3]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        center = view.center
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.scene.rootNode.addChildNode(arrow)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    var gameHasStarted = false
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if !gameHasStarted {
            let hitTest = sceneView.hitTest(center, types: .existingPlaneUsingExtent)
            let restult = hitTest.last
            guard let transform = restult?.worldTransform else { return }
            let thirdColumn = transform.columns.3
            let position = SCNVector3Make(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            arrowPositions.append(position)
            // Average the last 10 positions of the arrow.
            let lastTenPositions = arrowPositions.suffix(10)
            arrow.position = getAveragePosition(from: lastTenPositions)
        }
    }
    
    // MARK: - ARSCNViewDelegate
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        let extent = planeAnchor.extent
//        let planeGeometry = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.y))
//        planeGeometry.firstMaterial?.colorBufferWriteMask = []
//        planeGeometry.firstMaterial?.isDoubleSided = true
//        
//        guard let airportNode = node.childNode(withName: "Tower", recursively: false) else { return }
//        guard let runwayNode = node.childNode(withName: "Runway", recursively: false) else { return }
//        node.addChildNode(airportNode)
//        node.addChildNode(runwayNode)
//
//        let center = planeAnchor.center
//        node.position = SCNVector3Make(center.x, 0, center.z)
//        sceneView.scene.rootNode.addChildNode(node)
//    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameHasStarted {
            print("Start game.")
        } else {
            let aircraft = AirplaneNodes()
            guard let angle = sceneView.session.currentFrame?.camera.eulerAngles.y else { return }
            airportScene.position = arrow.position
            airportScene.eulerAngles.y = angle
            gameHasStarted = true
            sceneView.scene.rootNode.addChildNode(airportScene)
            arrow.removeFromParentNode()
            
            aircraft.addAircraft()
            aircraft.position = arrow.position
            sceneView.scene.rootNode.addChildNode(aircraft)
        }
    }
    
    

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
