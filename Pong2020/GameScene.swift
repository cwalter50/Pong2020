//
//  GameScene.swift
//  Pong2020
//
//  Created by Christopher Walter on 12/14/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    
    
    override func didMove(to view: SKView)
    {
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0.0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 5, dy: 9.8)
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
//         physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        makeNewBall(loc: location!)
    }
    
    func makeNewBall(loc: CGPoint)
    {
        let newBall = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100, height: 100))
        
        newBall.position = loc
        newBall.texture = SKTexture(imageNamed: "withers")
        addChild(newBall)
        
        newBall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        newBall.physicsBody?.affectedByGravity = true
        newBall.physicsBody?.friction = 0
        newBall.physicsBody?.allowsRotation = true
        newBall.physicsBody?.restitution = 1.0
        
    }
    

    
   
}
