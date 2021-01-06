//
//  GameScene.swift
//  Pong2020
//
//  Created by Christopher Walter on 12/14/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var paddle = SKSpriteNode()
    var ball = SKSpriteNode()
    var compPaddle = SKSpriteNode()
    var bottom = SKSpriteNode()
    var top = SKSpriteNode()
    var playerScoreLabel = SKLabelNode()
    var computerScoreLabel = SKLabelNode()
    var playerScore = 0
    {
        didSet {
            playerScoreLabel.text = "\(playerScore)"
        }
    }
    var computerScore = 0
    {
        didSet {
            computerScoreLabel.text = "\(computerScore)"
        }
    }
    
    override func didMove(to view: SKView)
    {
        // get access to the paddle
        paddle = childNode(withName: "paddle") as! SKSpriteNode
        
        // get access to the ball
        ball = childNode(withName: "ball") as! SKSpriteNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 300))
        
        createComputerPaddle()
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0.0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
//         physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)

        createTopAndBottomNodes()
        createLabels()
        
        physicsWorld.contactDelegate = self
        
        ball.physicsBody?.categoryBitMask = 1
        top.physicsBody?.categoryBitMask = 4
        bottom.physicsBody?.categoryBitMask = 4
        
        ball.physicsBody?.contactTestBitMask = 4
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1) && (contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4)
        {
            print(contact.contactPoint)
            if contact.bodyA.node == top || contact.bodyB.node == top
            {
                playerScore += 1
            }
            else
            {
                computerScore += 1
            }
            resetBall()
        }
    }
    
    func resetBall()
    {
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // stop ball
        let wait = SKAction.wait(forDuration: 1)
        
        let center = SKAction.run {
            self.ball.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        }
        
        let push = SKAction.run {
            self.ball.physicsBody?.applyImpulse(CGVector(dx: 200, dy: -200))
        }
        
        let sequence = SKAction.sequence([wait, center, wait, push])
        run(sequence)
        
    }
    
    
    
    func createLabels()
    {
        playerScoreLabel = SKLabelNode(fontNamed: "Avenir")
        playerScoreLabel.text = "0"
//        playerScoreLabel.text = "🤪"
        playerScoreLabel.fontSize = 75
        playerScoreLabel.color = UIColor.white
        playerScoreLabel.position = CGPoint(x: frame.width*0.25, y: frame.height*0.2)
        addChild(playerScoreLabel)
//        playerScoreLabel.physicsBody = SKPhysicsBody(rectangleOf: playerScoreLabel.frame.size)
        
        computerScoreLabel = SKLabelNode(fontNamed: "Avenir")
        computerScoreLabel.text = "0"
        computerScoreLabel.fontSize = 75
        computerScoreLabel.color = UIColor.white
        computerScoreLabel.position = CGPoint(x: frame.width*0.75, y: frame.height*0.7)
        addChild(computerScoreLabel)
    }
    
    func createTopAndBottomNodes()
    {
        bottom = SKSpriteNode(color: UIColor.systemPink, size: CGSize(width: frame.width, height: 50))
        bottom.position = CGPoint(x: frame.width*0.5, y: 100)
        addChild(bottom)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.frame.size)
        bottom.physicsBody?.isDynamic = false
        
        top = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width, height: 50))
        top.position = CGPoint(x: frame.width*0.5, y: frame.height-100)
        addChild(top)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.frame.size)
        top.physicsBody?.isDynamic = false
        
        
    }
    
    
    
    func createComputerPaddle()
    {
        compPaddle = SKSpriteNode(color: UIColor.green, size: CGSize(width: 200, height: 50))
        compPaddle.position = CGPoint(x: frame.width*0.5, y: frame.height*0.8)
        compPaddle.physicsBody = SKPhysicsBody(rectangleOf: compPaddle.frame.size)
        
        compPaddle.physicsBody?.allowsRotation = false
        compPaddle.physicsBody?.friction = 0.0
        compPaddle.physicsBody?.isDynamic = false
        compPaddle.physicsBody?.restitution = 1.0
        
        addChild(compPaddle)
        let sequence = SKAction.sequence([
            SKAction.run(moveComputerPaddle),
            SKAction.wait(forDuration: 0.2)
        ])
        
        run(SKAction.repeatForever(sequence))
        
    }
    
    func moveComputerPaddle()
    {
        let move = SKAction.moveTo(x: ball.position.x, duration: 0.3)
        compPaddle.run(move)
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
