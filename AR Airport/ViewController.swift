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


class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var subView: SKView!
    
    let arrow = SCNScene(named: "art.scnassets/rings.scn")!.rootNode
    let airportScene = SCNScene(named: "art.scnassets/runway.scn")!.rootNode
    
    var arrowPositions = [SCNVector3]()
    var center: CGPoint!
    var gameHasStarted = false
    
    var controlScene: ControlScene?
    var airplane: AirplaneNode?
    var airplaneAnchor: ARAnchor?
    var anchorTransform: simd_float4x4?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        center = view.center
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.scene.rootNode.addChildNode(arrow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameHasStarted {
            // game has started
        } else {
            guard let angle = sceneView.session.currentFrame?.camera.eulerAngles.y else { return }
            
            airportScene.position = arrow.position
            airportScene.eulerAngles.y = angle

            guard let transform = anchorTransform else {
                print("Transform not defined yet, skipping...")
                return }
            airplaneAnchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: airplaneAnchor!)
            sceneView.scene.rootNode.addChildNode(airportScene)
            arrow.removeFromParentNode()
            gameHasStarted = true
            loadControls()
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
