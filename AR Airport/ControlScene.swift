//
//  ControlScene.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 1/7/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import SpriteKit

class ControlScene: SKScene {
    
    let yokeBase = SKSpriteNode(imageNamed: "yokeBase")
    let controlYoke = SKSpriteNode(imageNamed: "yoke")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        backgroundColor.withAlphaComponent(0.8)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        yokeBase.position = CGPoint(x: 200, y: 0)
        controlYoke.position = yokeBase.position
        
        addChild(yokeBase)
        addChild(controlYoke)
    }
    
    var didTouchYoke = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if controlYoke.frame.contains(location) {
                didTouchYoke = true
            } else {
                didTouchYoke = false
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if didTouchYoke {
            
            for touch in touches {
                let location = touch.location(in: self)
                
                let vector = CGVector(dx: location.x - yokeBase.position.x, dy: location.y - yokeBase.position.y)
                let angle = atan2(vector.dy, vector.dx)
                let touchDegrees = angle * CGFloat(180 / Double.pi)
                print(touchDegrees + 180)
                
                let lengthFromBase = yokeBase.frame.size.height / 2
                
                let xDistance = sin(angle - 1.57079633) * lengthFromBase
                let yDistance = cos(angle - 1.57079633) * lengthFromBase
                
                if yokeBase.frame.contains(location) {
                    controlYoke.position = location
                } else {
                    controlYoke.position = CGPoint(x: yokeBase.position.x - xDistance, y: yokeBase.position.y + yDistance)
                }
                
                // Move the plane
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Move yoke back to center when touches end.
        if didTouchYoke {
            let moveYokeToCenter = SKAction.move(to: yokeBase.position, duration: 0.1)
            moveYokeToCenter.timingMode = .easeOut
            controlYoke.run(moveYokeToCenter)
        }
    }
}
