//
//  ViewController.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 12/14/18.
//  Copyright © 2018 Impulse Coupled Dev. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var subView: SKView!
    
    let arrow = SCNScene(named: "art.scnassets/rings.scn")!.rootNode
    let airportScene = SCNScene(named: "art.scnassets/runway.scn")!.rootNode
    var arrowPositions = [SCNVector3]()
    var center: CGPoint!
    
    
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
    var airplane: AirplaneNode?
    var anchorTransform = simd_float4x4()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameHasStarted {
            // game has started
        } else {
            airplane = AirplaneNode()
            guard let angle = sceneView.session.currentFrame?.camera.eulerAngles.y else { return }
            airportScene.position = arrow.position
            airportScene.eulerAngles.y = angle
            
            let anchor = ARAnchor(transform: anchorTransform)
            sceneView.session.add(anchor: anchor)
            airplane?.position = arrow.position
            
            sceneView.scene.rootNode.addChildNode(airplane!)
            sceneView.scene.rootNode.addChildNode(airportScene)
            arrow.removeFromParentNode()
            
            loadControls()
            gameHasStarted = true
        }
    }
    
    
    func loadControls() {
        if let scene = SKScene(fileNamed: "ControlScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.backgroundColor = SKColor.clear
            
            // Present the scene
            subView.presentScene(scene)
        }
    }
    
    
    // MARK: - ARSCNViewDelegate
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
        if airplane == nil{
            airplane = AirplaneNode()
            airplane?.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
            node.addChildNode(airplane!)
            print("WE GOT IT")
        }
    }
    
    
    let controls = ControlScene()
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        node.childNode(withName: "787", recursively: true)
        node.eulerAngles = SCNVector3(90, 90, -1)
        
//        let action = SCNAction.moveBy(x: controls.controlYoke.position.x, y: controls.controlYoke.position.y, z: 0, duration: 1.0)
        
        node.eulerAngles.x = Float(controls.controlYoke.position.x)
        node.position.y = Float(controls.controlYoke.position.y)
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
