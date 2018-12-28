//
//  AircraftControls.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 12/20/18.
//  Copyright © 2018 Impulse Coupled Dev. All rights reserved.
//
import UIKit
import SpriteKit

class AircraftControls: SKScene {
    
    var throttleColumnNode: SKSpriteNode!
    var throttleHandleNode: SKSpriteNode!
    var yokeNode: SKSpriteNode!
    var scoreNode: SKLabelNode!
    var score = 0 {
        didSet {
            scoreNode.text = "Score: \(score)"
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        setUpScene()
    }
    
    
    func setUpScene() {
        let sceneSize = CGSize(width: size.width, height: size.height)
        
        throttleColumnNode = SKSpriteNode(imageNamed: "Column")
        throttleHandleNode = SKSpriteNode(imageNamed: "Handle")
        yokeNode = SKSpriteNode(imageNamed: "Yoke")
        
        throttleColumnNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        throttleColumnNode.position = CGPoint(x: sceneSize.width * 0.125, y: sceneSize.height * 0.5)
        throttleColumnNode.zPosition = -1
        
        throttleHandleNode.position = CGPoint(x: throttleColumnNode.position.x, y: 15)
        
        yokeNode.position = CGPoint(x: sceneSize.width * 0.75, y: sceneSize.height * 0.5)
        
        addChild(yokeNode)
        addChild(throttleHandleNode)
        addChild(throttleColumnNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
//    
//    
//    
//    override func didMove(to view: SKView) {
//        self.addChild(throttleColumn!)
//        throttleColumn?.position = CGPoint(x: 0, y: 0)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // Code
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//        }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Code
//    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
