//
//  ControlScene.swift
//  AR Airport
//
//  Created by Daniel O'Leary on 1/7/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import SpriteKit
import SceneKit

class ControlScene: SKScene {
    
    let yokeBase = SKSpriteNode(imageNamed: "yokeBase")
    let controlYoke = SKSpriteNode(imageNamed: "yoke")
    let throttleBase = SKSpriteNode(imageNamed: "throttleBase")
    let throttleColumn = SKSpriteNode(imageNamed: "column")
    let throttleHandle = SKSpriteNode(imageNamed: "throttleHandle")
    
    var didTouchYoke = false
    var didTouchThrottle = false
    
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        yokeBase.position = CGPoint(x: 250, y: 0)
        controlYoke.position = yokeBase.position
        throttleBase.position = CGPoint(x: -250, y: 0)
        
        throttleColumn.position = throttleBase.position
        throttleHandle.position = CGPoint(x: throttleColumn.position.x, y: throttleColumn.frame.minY)
        
        addChild(yokeBase)
        addChild(controlYoke)
        addChild(throttleBase)
        addChild(throttleColumn)
        addChild(throttleHandle)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if controlYoke.frame.contains(location) {
                didTouchYoke = true
            } else {
                didTouchYoke = false
            }
            
            if throttleBase.frame.contains(location) {
               didTouchThrottle = true
            } else {
                didTouchThrottle = false
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if didTouchYoke {
            for touch in touches {
                let location = touch.location(in: self)

                let vector = CGVector(dx: location.x - yokeBase.position.x, dy: location.y - yokeBase.position.y)
                let angle = atan2(vector.dy, vector.dx)
                touchDegrees = angle * CGFloat(180 / Double.pi)
                // Use touchDegrees + 180 to possibly be the output of the control. It represents logical output numbers.

                let lengthFromBase = yokeBase.frame.size.height / 2

                let xDistance = sin(angle - 1.57079633) * lengthFromBase
                let yDistance = cos(angle - 1.57079633) * lengthFromBase

                if yokeBase.frame.contains(location) {
                    controlYoke.position = location
                } else {
                    controlYoke.position = CGPoint(x: yokeBase.position.x - xDistance, y: yokeBase.position.y + yDistance)
                }
                // Apply pitch and roll
                print("Yoke positon X: \(controlYoke.position.x)")
            }
        }
        
        if didTouchThrottle {
            for touch in touches {
                let location = touch.location(in: self)

                if throttleBase.frame.contains(location) {
                    throttleHandle.position = CGPoint(x: throttleColumn.position.x, y: location.y)
                    throttlePercentage = getThrottlePosition(yPosition: throttleHandle.position.y, frameHeight: throttleColumn.frame.height)
                }
            }
            // Apply thrust
            print("Throttle position is \(throttleHandle.position.y)")
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Move yoke back to center when touches end.
        if didTouchYoke  {
            let moveYokeToCenter = SKAction.move(to: yokeBase.position, duration: 0.1)
            moveYokeToCenter.timingMode = .easeOut
            controlYoke.run(moveYokeToCenter)
        }
    }
    
    
    
}



