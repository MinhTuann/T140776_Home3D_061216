//
//  GameScene.swift
//  Homework3D
//
//  Created by Hoang Minh Tuan Vu on 6/4/16.
//  Copyright (c) 2016 Tuan Vu. All rights reserved.
//

import SpriteKit

//Physics Category
struct PhysicsCategory {
    static let Bird: UInt32 = 0x1 << 1
    static let Crown: UInt32 = 0x1 << 2
    static let Ground: UInt32 = 0x1 << 3
    static let Score: UInt32 = 0x1 << 4
    static let Wall: UInt32 = 0x1 << 5
    static let Coin: UInt32 = 0x1 << 6
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Sky: SKSpriteNode!
    var Ground: SKSpriteNode!
    var Bird: SKSpriteNode!
    var Bird2: SKSpriteNode!
    var Crown: SKSpriteNode!
    var Vehicle: SKSpriteNode!
    var Coin: SKSpriteNode!
    
    var WallLeft: SKSpriteNode!
    var WallRight: SKSpriteNode!
    
    var gameStarted: Bool = false
    var died: Bool = false
    var score: Int = 0 {
        didSet {
            myLabel.text = "\(score)"
        }
    }
    var BestScore: Int = 0
    
    var myLabel: SKLabelNode!
    var BestScorelb: SKLabelNode!
    
    var btnRestart: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        createScene()
    }
    
    func createScene() {
        let randomPositionX = CGFloat.random(min: self.size.width/8, max: self.size.width - 100)
        let randomPositionX2 = CGFloat.random(min: self.size.width/8, max: self.size.width - 100)
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let Cloud = SKSpriteNode(imageNamed: "Cloud")
            Cloud.anchorPoint = CGPointZero
            Cloud.size = CGSize(width: self.frame.width, height: self.frame.height/4)
            Cloud.position = CGPointMake(CGFloat(i) * self.frame.width, self.frame.height/2)
            Cloud.name = "Cloud"
            Cloud.zPosition = 2
            self.addChild(Cloud)
        }
        
        if BestScore <= score {
            BestScore = score
        }
        
        BestScorelb = SKLabelNode(fontNamed:"Chalkduster")
        BestScorelb.text = "Best Score: \(BestScorelb)"
        BestScorelb.fontSize = 10
        BestScorelb.position = CGPoint(x: self.frame.width/12, y: self.frame.height - 70)
        BestScorelb.zPosition = 5
        //self.addChild(BestScorelb)
        
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "\(score)"
        myLabel.fontSize = 60
        myLabel.position = CGPoint(x:self.frame.width/2, y: self.frame.height - 65)
        myLabel.zPosition = 5
        self.addChild(myLabel)
        
        WallLeft = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 10.0, height: self.frame.height*2))
        WallLeft.physicsBody = SKPhysicsBody(rectangleOfSize: WallLeft.size)
        WallLeft.position = CGPoint(x: -5.0, y: self.frame.height/2)
        WallLeft.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        WallLeft.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        WallLeft.physicsBody?.dynamic = false
        WallLeft.physicsBody?.affectedByGravity = false
        
        WallLeft.zPosition = 0
        self.addChild(WallLeft)
        
        WallRight = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 10.0, height: self.frame.height*2))
        WallRight.physicsBody = SKPhysicsBody(rectangleOfSize: WallRight.size)
        WallRight.position = CGPoint(x: self.size.width + 5.0, y: self.frame.height/2)
        WallRight.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        WallRight.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        WallRight.physicsBody?.dynamic = false
        WallRight.physicsBody?.affectedByGravity = false
        
        WallRight.zPosition = 0
        self.addChild(WallRight)
        
        Sky = SKSpriteNode(imageNamed: "Sky")
        Sky.size = CGSize(width: self.size.width, height: self.size.height)
        Sky.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        Sky.zPosition = 1
        self.addChild(Sky)
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.size = CGSize(width: self.size.width, height: self.size.width/10)
        Ground.position = CGPoint(x: self.size.width/2, y: 0 + Ground.frame.height/2)
        
        Ground.physicsBody = SKPhysicsBody(texture: Ground.texture!, size: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        Ground.physicsBody?.dynamic = false
        Ground.physicsBody?.affectedByGravity = false
        
        Ground.zPosition = 2
        self.addChild(Ground)
        
        let textureBird11 = SKTexture(imageNamed: "Bird1-1")
        let textureBird12 = SKTexture(imageNamed: "Bird1-2")
        let textureBird13 = SKTexture(imageNamed: "Bird1-3")
        let textureBird14 = SKTexture(imageNamed: "Bird1-4")
        let textureBird15 = SKTexture(imageNamed: "Bird1-5")
        
        let fly1 = SKAction.animateWithTextures([textureBird11, textureBird12, textureBird13, textureBird14,textureBird15], timePerFrame: 0.2)
        let flyForever1 = SKAction.repeatActionForever(fly1)
        
        Bird = SKSpriteNode(imageNamed: "Bird1-1")
        Bird.size = CGSize(width: self.frame.width/7, height: self.frame.height/11)
        Bird.physicsBody = SKPhysicsBody(texture: textureBird11, size: Bird.size)
        Bird.runAction(flyForever1)
        Bird.position = CGPoint(x: randomPositionX, y: self.frame.height + 60)
        Bird.physicsBody?.categoryBitMask = PhysicsCategory.Bird
        Bird.physicsBody?.collisionBitMask = PhysicsCategory.Crown | PhysicsCategory.Wall | PhysicsCategory.Ground
        Bird.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Crown | PhysicsCategory.Score
        Bird.physicsBody?.dynamic = true
        Bird.physicsBody?.affectedByGravity = false
        
        Bird.zPosition = 3
        self.addChild(Bird)
        
        let textureBird21 = SKTexture(imageNamed: "Bird2-1")
        let textureBird22 = SKTexture(imageNamed: "Bird2-2")
        let textureBird23 = SKTexture(imageNamed: "Bird2-3")
        let textureBird24 = SKTexture(imageNamed: "Bird2-4")
        let textureBird25 = SKTexture(imageNamed: "Bird2-5")
        
        let fly2 = SKAction.animateWithTextures([textureBird21, textureBird22, textureBird23, textureBird24,textureBird25], timePerFrame: 0.2)
        let flyForever2 = SKAction.repeatActionForever(fly2)
        
        Bird2 = SKSpriteNode(imageNamed: "Bird2-1")
        Bird2.size = CGSize(width: self.frame.width/7, height: self.frame.height/11)
        Bird2.physicsBody = SKPhysicsBody(texture: textureBird21, size: Bird2.size)
        Bird2.runAction(flyForever2)
        Bird2.position = CGPoint(x: randomPositionX2, y: self.frame.height + 60)
        Bird2.physicsBody?.categoryBitMask = PhysicsCategory.Bird
        Bird2.physicsBody?.collisionBitMask = PhysicsCategory.Crown | PhysicsCategory.Wall | PhysicsCategory.Ground
        Bird2.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Crown | PhysicsCategory.Score
        Bird2.physicsBody?.dynamic = true
        Bird2.physicsBody?.affectedByGravity = false
        
        Bird2.zPosition = 3
        self.addChild(Bird2)
        
        createCrown()
        createVehicle()
    }
    
    func restartScene() {
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createCoin() {
        let randomPositionY = CGFloat.random(min: self.size.height/3, max: self.size.height - 100)
        let randomPositionX = CGFloat.random(min: self.size.width/5, max: self.size.width - 50)
        
        let scale = SKAction.scaleTo(1.0, duration: 0.3)
        let delay = SKAction.waitForDuration(3.0)
        let Spawndelay = SKAction.sequence([delay, scale])
        
        Coin = SKSpriteNode(imageNamed: "Coin")
        Coin.name = "Coin"
        Coin.size = CGSize(width: self.frame.width/7, height: self.frame.height/11)
        Coin.physicsBody = SKPhysicsBody(texture: Coin.texture!, size: Coin.size)
        Coin.position = CGPoint(x: randomPositionX, y: randomPositionY)
        Coin.runAction(Spawndelay)
        Coin.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        Coin.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        Coin.zPosition = 3
        Coin.physicsBody?.dynamic = false
        Coin.physicsBody?.affectedByGravity = false
        self.addChild(Coin)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.0)
        
        let randomPositionX = CGFloat.random(min: -10, max: 10)
        let randomPositionX2 = CGFloat.random(min: -10, max: 10)
        
        let locaBird = Bird.position
        let locaBird2 = Bird2.position
        
        if gameStarted == false {
            gameStarted = true
            
            Bird.physicsBody?.affectedByGravity = true
            let spawn = SKAction.runBlock({
                () in
                self.createCoin()
            })
            let delay = SKAction.waitForDuration(13.0)
            let Spawndelay = SKAction.sequence([spawn, delay])
            let SpawnForever = SKAction.repeatActionForever(Spawndelay)
            self.runAction(SpawnForever)
            
            for touch in touches {
                
                let location = touch.locationInNode(self)
                
                if (locaBird.y - 60) < location.y && location.y < (locaBird.y + 60) && (locaBird.x - 60) < location.x && location.x < (locaBird.x + 60) {
                    
                    Bird.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
                    Bird.physicsBody?.applyImpulse(CGVectorMake(randomPositionX, 20.0))
                }
                if (locaBird2.y - 60) < location.y && location.y < (locaBird2.y + 60) && (locaBird2.x - 60) < location.x && location.x < (locaBird2.x + 60) {
                    
                    Bird2.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
                    Bird2.physicsBody?.applyImpulse(CGVectorMake(randomPositionX2, 20.0))
                }
                    
                else {
                }
            }
        }
            
        else {
            if died == true {
                
            }
            else {
                for touch in touches {
                    let location = touch.locationInNode(self)
                    
                    if (locaBird.y - 60) < location.y && location.y < (locaBird.y + 60) && (locaBird.x - 60) < location.x && location.x < (locaBird.x + 60) {
                        
                        Bird.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
                        Bird.physicsBody?.applyImpulse(CGVectorMake(randomPositionX, 20.0))
                        
                    }
                    
                    if (locaBird2.y - 60) < location.y && location.y < (locaBird2.y + 60) && (locaBird2.x - 60) < location.x && location.x < (locaBird2.x + 60) {
                        
                        Bird2.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
                        Bird2.physicsBody?.applyImpulse(CGVectorMake(randomPositionX2, 20.0))
                    }
                        
                    else {
                    }
                }
            }
        }
        
        for touche in touches {
            let location = touche.locationInNode(self)
            
            if died == true {
                
                if btnRestart.containsPoint(location) {
                    restartScene()
                }
                
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        let randomPositionY = CGFloat.random(min: self.size.height/2 - 100, max: self.size.height - 100)
        
        if gameStarted == true {
            
            if died == false {
                if score >= 1 {
                    Bird2.physicsBody?.affectedByGravity = true
                }
                enumerateChildNodesWithName("Cloud", usingBlock: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    bg.position = CGPointMake(bg.position.x - 1, bg.position.y)
                    
                    if bg.position.x <= -bg.size.width {
                        
                        bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y)
                        
                    }
                    
                }))
                
                enumerateChildNodesWithName("Vehicle", usingBlock: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    bg.position = CGPointMake(bg.position.x + 1, bg.position.y)
                    
                    if bg.position.x >= (self.frame.width + 90) {
                        
                        bg.position = CGPointMake(-90 , bg.position.y)
                        
                    }
                    
                }))
                
                enumerateChildNodesWithName("Crown", usingBlock: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    bg.position = CGPointMake(bg.position.x - 2, bg.position.y)
                    
                    if bg.position.x <= -40.0 {
                        self.score = self.score + 1
                        print(self.score)
                        bg.position = CGPointMake(bg.position.x + self.size.width * 2, randomPositionY)
                        
                    }
                    
                }))
                
            }
            
        }
        
    }
    
    func createbtnPlay() {
        btnRestart = SKSpriteNode(imageNamed: "play")
        btnRestart.size = CGSizeMake(100, 100)
        btnRestart.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        btnRestart.setScale(0)
        btnRestart.zPosition = 5
        self.addChild(btnRestart)
        
        btnRestart.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        
        //        if BestScore <= score {
        //            BestScore = score
        //        }
        //
        //        BestScorelb = SKLabelNode(fontNamed:"Chalkduster")
        //        BestScorelb.text = "\(BestScorelb)"
        //        BestScorelb.fontSize = 65
        //        BestScorelb.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 100)
        //        BestScorelb.zPosition = 5
        //        //self.addChild(BestScorelb)
    }
    
    func createCrown() {
        
        let randomPositionY = CGFloat.random(min: self.size.height/2, max: self.size.height - 100)
        
        let textureCrown1 = SKTexture(imageNamed: "1")
        let textureCrown2 = SKTexture(imageNamed: "2")
        let textureCrown3 = SKTexture(imageNamed: "3")
        
        let fly = SKAction.animateWithTextures([textureCrown1, textureCrown2, textureCrown3], timePerFrame: 0.5)
        let flyForever = SKAction.repeatActionForever(fly)
        
        Crown = SKSpriteNode(imageNamed: "1")
        Crown.name = "Crown"
        Crown.size = CGSize(width: self.frame.width/7, height: self.frame.height/8)
        Crown.physicsBody = SKPhysicsBody(texture: textureCrown1, size: Crown.size)
        Crown.runAction(flyForever)
        
        Crown.position = CGPoint(x: self.frame.width + 100, y: randomPositionY)
        Crown.physicsBody?.categoryBitMask = PhysicsCategory.Crown
        Crown.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        Crown.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        Crown.physicsBody?.affectedByGravity = false
        Crown.physicsBody?.dynamic = false
        
        Crown.zPosition = 3
        self.addChild(Crown)
    }
    
    func createVehicle() {
        Vehicle = SKSpriteNode(imageNamed: "Vehicle")
        Vehicle.name = "Vehicle"
        
        Vehicle.size = CGSize(width: self.frame.width/7, height: self.frame.height/8)
        Vehicle.physicsBody = SKPhysicsBody(texture: Vehicle.texture!, size: Vehicle.size)
        Vehicle.position = CGPoint(x: -60, y: Ground.position.y + Ground.frame.height + 10)
        
        Vehicle.physicsBody?.categoryBitMask = PhysicsCategory.Crown
        Vehicle.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        Vehicle.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        Vehicle.physicsBody?.affectedByGravity = false
        Vehicle.physicsBody?.dynamic = false
        
        Vehicle.zPosition = 3
        self.addChild(Vehicle)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Bird && secondBody.categoryBitMask == PhysicsCategory.Ground || firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Bird {
            
            enumerateChildNodesWithName("Crown", usingBlock: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            
            if died == false {
                died = true
                createbtnPlay()
            }
        }
        if firstBody.categoryBitMask == PhysicsCategory.Bird && secondBody.categoryBitMask == PhysicsCategory.Crown || firstBody.categoryBitMask == PhysicsCategory.Crown && secondBody.categoryBitMask == PhysicsCategory.Bird {
            
            enumerateChildNodesWithName("Crown", usingBlock: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            
            if died == false {
                died = true
                createbtnPlay()
            }
        }
        if firstBody.categoryBitMask == PhysicsCategory.Bird && secondBody.categoryBitMask == PhysicsCategory.Coin {
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Coin && secondBody.categoryBitMask == PhysicsCategory.Bird {
            firstBody.node?.removeFromParent()
        }
        
    }
    
}
