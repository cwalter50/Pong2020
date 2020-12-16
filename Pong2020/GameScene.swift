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
    var paddle = SKSpriteNode()
    var ball = SKSpriteNode()
    
    override func didMove(to view: SKView)
    {
        // get access to the paddle
        paddle = childNode(withName: "paddle") as! SKSpriteNode
        
        // get access to the ball
        ball = childNode(withName: "ball") as! SKSpriteNode
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0.0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
//         physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)

        
    }
    
    var isFingerOnPaddle = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first!.location(in: self)
//        makeNewBall(loc: location!)
        if paddle.frame.contains(location)
        {
            isFingerOnPaddle = true
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first!.location(in: self)
        if isFingerOnPaddle == true
        {
            paddle.position = CGPoint(x: location.x, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        isFingerOnPaddle = false
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
