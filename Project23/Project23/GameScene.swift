//
//  GameScene.swift
//  Project23
//
//  Created by Alperen Çerkez on 13.12.2024.
//

import AVFoundation
import SpriteKit

enum ForceBomb {
    case never, always, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    // MARK: - Properties
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    var activeEnemies = [SKSpriteNode]()
    var bombSoundEffect: AVAudioPlayer?
    
    var popUpTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    var isGameEnded = false
    
    let enemyMinXPosition: CGFloat = 64
    let enemyMaxXPosition: CGFloat = 960
    let enemyMinYPosition: CGFloat = -128
    let enemyMaxYVelocity: Int = 24
    let enemyMinYVelocity: Int = 8
    let enemyAngularVelocityRange: CGFloat = 3

    let bonusEnemySpeedMultiplier: CGFloat = 2.0
    let bonusEnemyPoints: Int = 10

    
    override func didMove(to view: SKView) {
        setupScene()
        initializeSequence()
        scheduleEnemyToss()
    }
    
    
    func setupScene() {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.position = CGPoint(x: 8, y: 8)
        addChild(gameScore)
        score = 0
    }
    
    func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    func initializeSequence() {
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        for _ in 0..<1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
    }
    
    func scheduleEnemyToss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        activeSlicePoints.append(touch.location(in: self))
        redrawActiveSlice()
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false, let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        for node in nodes(at: location) {
            handleEnemyHit(node)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        for point in activeSlicePoints[1...] {
            path.addLine(to: point)
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    
    func tossEnemies() {
        guard !isGameEnded else { return }
        
        popUpTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            for _ in 0..<3 { createEnemy() }
        case .four:
            for _ in 0..<4 { createEnemy() }
        case .chain:
            chainEnemies(delayMultiplier: 5.0)
        case .fastChain:
            chainEnemies(delayMultiplier: 10.0)
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    func chainEnemies(delayMultiplier: Double) {
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / delayMultiplier) * Double(i)) { [weak self] in
                self?.createEnemy()
            }
        }
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        let enemyType = (forceBomb == .always ? 0 : forceBomb == .never ? 1 : Int.random(in: 0...6))
        
        if enemyType == 0 {
            enemy = setupBomb()
        } else if enemyType == 6 {
            enemy = setupBonusEnemy()
        } else {
            enemy = setupNormalEnemy()
        }
        
        positionAndAddEnemy(enemy)
    }
    
    func setupBomb() -> SKSpriteNode {
        let bomb = SKSpriteNode(imageNamed: "sliceBomb")
        bomb.name = "bomb"
        
        let bombFuse = SKSpriteNode(imageNamed: "sliceFuse")
        bombFuse.position = CGPoint(x: 76, y: 64)
        bomb.addChild(bombFuse)
        
        if let sound = bombSoundEffect { sound.stop() }
        let path = Bundle.main.path(forResource: "sliceBombFuse", ofType: "caf")!
        bombSoundEffect = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        bombSoundEffect?.play()
        
        return bomb
    }
    
    func setupBonusEnemy() -> SKSpriteNode {
        let bonusEnemy = SKSpriteNode(imageNamed: "bonusEnemy")
        bonusEnemy.name = "bonus"
        return bonusEnemy
    }
    
    func setupNormalEnemy() -> SKSpriteNode {
        let normalEnemy = SKSpriteNode(imageNamed: "penguin")
        normalEnemy.name = "enemy"
        return normalEnemy
    }
    
    func positionAndAddEnemy(_ enemy: SKSpriteNode) {
        let randomXPosition = Int.random(in: Int(enemyMinXPosition)...Int(enemyMaxXPosition))
        let randomYVelocity = Int.random(in: enemyMinYVelocity...enemyMaxYVelocity)
        let randomAngularVelocity = CGFloat.random(in: -enemyAngularVelocityRange...enemyAngularVelocityRange)
        
        enemy.position = CGPoint(x: randomXPosition, y: Int(enemyMinYPosition))
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: 0, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        if enemy.name == "bonus" {
            enemy.physicsBody?.velocity.dy *= Int(bonusEnemySpeedMultiplier)
        }
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func handleEnemyHit(_ node: SKNode) {
        guard let spriteNode = node as? SKSpriteNode else { return }
        
        if spriteNode.name == "enemy" {
            createExplosion(at: spriteNode.position, type: "sliceHitEnemy")
            score += 1
        } else if spriteNode.name == "bonus" {
            createExplosion(at: spriteNode.position, type: "sliceHitBonus")
            score += bonusEnemyPoints
        } else if spriteNode.name == "bomb" {
            createExplosion(at: spriteNode.position, type: "sliceHitBomb")
            endGame(triggeredByBomb: true)
        }
        
        spriteNode.removeFromParent()
        activeEnemies.removeAll { $0 == spriteNode }
    }
    
    func createExplosion(at position: CGPoint, type: String) {
        if let emitter = SKEmitterNode(fileNamed: type) {
            emitter.position = position
            addChild(emitter)
        }
    }
    
    func endGame(triggeredByBomb: Bool) {
        guard !isGameEnded else { return }
        isGameEnded = true
        physicsWorld.speed = 0
        bombSoundEffect?.stop()
        
        for node in children {
            if node.name == "enemy" || node.name == "bomb" || node.name == "bonus" {
                node.removeFromParent()
            }
        }
        
        if triggeredByBomb {
            lives = 0
            updateLivesImages()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.restartGame()
        }
    }
    
    func restartGame() {
        
        score = 0
        lives = 3
        sequencePosition = 0
        popUpTime = 0.9
        chainDelay = 3.0
        physicsWorld.speed = 0.85
        isGameEnded = false
        
        updateLivesImages()
        initializeSequence()
        scheduleEnemyToss()
    }
    
    func updateLivesImages() {
        for (index, image) in livesImages.enumerated() {
            if index < lives {
                image.texture = SKTexture(imageNamed: "sliceLife")
            } else {
                image.texture = SKTexture(imageNamed: "sliceLifeGone")
            }
        }
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        let soundName = "swoosh\(Int.random(in: 1...3)).caf"
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.isEmpty {
            if !nextSequenceQueued {
                scheduleEnemyToss()
                nextSequenceQueued = true
            }
        } else {
            for (index, enemy) in activeEnemies.enumerated().reversed() {
                if enemy.position.y < -140 {
                    activeEnemies.remove(at: index)
                    enemy.removeFromParent()
                    
                    if enemy.name == "enemy" || enemy.name == "bonus" {
                        subtractLife()
                    }
                }
            }
        }
    }
    
    func subtractLife() {
        guard lives > 0 else { return }
        lives -= 1
        
        if lives == 0 {
            endGame(triggeredByBomb: false)
        } else {
            updateLivesImages()
        }
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
    }
}
