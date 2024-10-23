import SpriteKit
import GameplayKit
import AVFAudio

class LimoChaser: SKScene {
    
    weak var gameplayViewController: GameplayViewController?
    
    var redColorSelectionButtonNode: SKSpriteNode!
    var greenColorSelectionButtonNode: SKSpriteNode!
    var blueColorSelectionButtonNode: SKSpriteNode!
    
    var fullWidthImageNode: SKSpriteNode!
    
    var redLaunchBallButtonNode: SKSpriteNode!
    var greenLaunchBallButtonNode: SKSpriteNode!
    var blueLaunchBallButtonNode: SKSpriteNode!
    
    var currentlySelectedColorButtonNode: SKSpriteNode?
    var collisionCountLabel: SKLabelNode!
    var collisionCount: Int = 0
    
    var fallingBallSpawnInterval: TimeInterval = 2.0
    
    var targetcollisionCount = 0
    
    var yPos: CGFloat = 0.0
    
    var playerAudio: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        setupCollisionCountLabelForCollisionTracking()
        setupBackgroundNode()
        setupColorSelectionButtons()
        setupLaunchBallButtons()
        startFallingBallSpawnSequence()
    }
    
    func setupBackgroundNode() {
        let img = UserDefaults.standard.string(forKey: "CurrentBackground") ?? "BlurBackGroundForApp"
        let backgroundNode = SKSpriteNode(imageNamed: img)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -1
        backgroundNode.size = size
        addChild(backgroundNode)
    }
    
    func setupColorSelectionButtons() {
        redColorSelectionButtonNode = createColorSelectionButton(buttonName: "RedButton", buttonColor: .red)
        greenColorSelectionButtonNode = createColorSelectionButton(buttonName: "GreenButton", buttonColor: .green)
        blueColorSelectionButtonNode = createColorSelectionButton(buttonName: "BlueButton", buttonColor: .blue)
        
        let buttonSize = size.width * 0.28
        let buttonPadding = size.width * 0.03
        
        redColorSelectionButtonNode.position = CGPoint(x: buttonSize / 2 + buttonPadding, y: redColorSelectionButtonNode.size.height / 2 + 20)
        addChild(redColorSelectionButtonNode)
        
        greenColorSelectionButtonNode.position = CGPoint(x: size.width / 2, y: greenColorSelectionButtonNode.size.height / 2 + 20)
        addChild(greenColorSelectionButtonNode)
        
        blueColorSelectionButtonNode.position = CGPoint(x: size.width - buttonSize / 2 - buttonPadding, y: blueColorSelectionButtonNode.size.height / 2 + 20)
        addChild(blueColorSelectionButtonNode)
    }
    
    func setupCollisionCountLabelForCollisionTracking() {
        collisionCountLabel = SKLabelNode(text: "\(collisionCount)")
        collisionCountLabel.fontName = "Questrian"
        collisionCountLabel.fontSize = 72
        collisionCountLabel.position = CGPoint(x: size.width / 2, y: size.height/2)
        collisionCountLabel.zPosition = 0
        addChild(collisionCountLabel)
    }
    
    func setupLaunchBallButtons() {
        redLaunchBallButtonNode = createLaunchBallButton(buttonName: "RedLaunchButton", buttonColor: .red)
        greenLaunchBallButtonNode = createLaunchBallButton(buttonName: "GreenLaunchButton", buttonColor: .green)
        blueLaunchBallButtonNode = createLaunchBallButton(buttonName: "BlueLaunchButton", buttonColor: .blue)
        
        let launchButtonSize = CGSize(width: size.width * 0.28, height: size.width * 0.15)
        
        redLaunchBallButtonNode.position = CGPoint(x: redColorSelectionButtonNode.position.x, y: redColorSelectionButtonNode.position.y + redColorSelectionButtonNode.size.height / 2 + launchButtonSize.height / 2 + 10)
        greenLaunchBallButtonNode.position = CGPoint(x: greenColorSelectionButtonNode.position.x, y: greenColorSelectionButtonNode.position.y + greenColorSelectionButtonNode.size.height / 2 + launchButtonSize.height / 2 + 10)
        blueLaunchBallButtonNode.position = CGPoint(x: blueColorSelectionButtonNode.position.x, y: blueColorSelectionButtonNode.position.y + blueColorSelectionButtonNode.size.height / 2 + launchButtonSize.height / 2 + 10)
        
        addChild(redLaunchBallButtonNode)
        addChild(greenLaunchBallButtonNode)
        addChild(blueLaunchBallButtonNode)
        
        yPos = CGFloat(blueLaunchBallButtonNode.position.y) + CGFloat(50)
        
        fullWidthImageNode = SKSpriteNode(imageNamed: "GameOverPlatform")
        fullWidthImageNode.size = CGSize(width: size.width, height: size.width * 0.1)
        fullWidthImageNode.position = CGPoint(x: size.width / 2, y: yPos)
        addChild(fullWidthImageNode)
    }
    
    func createColorSelectionButton(buttonName: String, buttonColor: UIColor) -> SKSpriteNode {
        let colorSelectionButtonNode = SKSpriteNode(imageNamed: buttonName)
        colorSelectionButtonNode.color = buttonColor
        colorSelectionButtonNode.size = CGSize(width: size.width * 0.28, height: size.width * 0.28)
        colorSelectionButtonNode.name = buttonName
        return colorSelectionButtonNode
    }
    
    func createLaunchBallButton(buttonName: String, buttonColor: UIColor) -> SKSpriteNode {
        let launchBallButtonNode = SKSpriteNode(imageNamed: "PolygonButton")
        launchBallButtonNode.color = buttonColor
        launchBallButtonNode.size = CGSize(width: size.width * 0.28, height: size.width * 0.15)
        launchBallButtonNode.name = buttonName
        return launchBallButtonNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let touchLocation = firstTouch.location(in: self)
        
        if let touchedNode = atPoint(touchLocation) as? SKSpriteNode {
            switch touchedNode.name {
            case "RedButton", "GreenButton", "BlueButton":
                handleColorSelection(selectedButtonNode: touchedNode)
            case "RedLaunchButton", "GreenLaunchButton", "BlueLaunchButton":
                launchBall(from: touchedNode)
            default:
                break
            }
        }
    }
    
    func handleColorSelection(selectedButtonNode: SKSpriteNode) {
        if let previouslySelectedButton = currentlySelectedColorButtonNode {
            previouslySelectedButton.alpha = 1.0
        }
        
        currentlySelectedColorButtonNode = selectedButtonNode
        currentlySelectedColorButtonNode?.alpha = 0.65
    }
    
    func launchBall(from launchButtonNode: SKSpriteNode) {
        
        if  UserDefaults.standard.bool(forKey: "isSoundTrue") {
            guard let url = Bundle.main.url(forResource: "fire", withExtension: "wav") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
        
        guard let selectedColorButtonNode = currentlySelectedColorButtonNode else { return }
        
        let launchedBallImageName: String
        switch selectedColorButtonNode.name {
        case "RedButton":
            launchedBallImageName = "RedBall"
        case "GreenButton":
            launchedBallImageName = "GreenBall"
        case "BlueButton":
            launchedBallImageName = "BlueBall"
        default:
            return
        }
        
        let launchedBallNode = SKSpriteNode(imageNamed: launchedBallImageName)
        launchedBallNode.size = CGSize(width: 45, height: 45)
        launchedBallNode.position = CGPoint(x: launchButtonNode.position.x, y: yPos+55)
        launchedBallNode.physicsBody = SKPhysicsBody(circleOfRadius: launchedBallNode.size.width / 2)
        launchedBallNode.physicsBody?.affectedByGravity = false
        launchedBallNode.name = launchedBallImageName
        
        launchedBallNode.physicsBody?.categoryBitMask = PhysicsCategory.LaunchBall
        launchedBallNode.physicsBody?.contactTestBitMask = PhysicsCategory.FallingBall
        launchedBallNode.physicsBody?.collisionBitMask = 0
        
        let moveUpAction = SKAction.moveBy(x: 0, y: size.height, duration: 3.0)
        let removeAction = SKAction.removeFromParent()
        launchedBallNode.run(SKAction.sequence([moveUpAction, removeAction]))
        
        addChild(launchedBallNode)
    }

    
    func startFallingBallSpawnSequence() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnRandomFallingBall()
        }
        let waitAction = SKAction.wait(forDuration: fallingBallSpawnInterval)
        let spawnSequence = SKAction.sequence([spawnAction, waitAction])
        let repeatSpawnAction = SKAction.repeatForever(spawnSequence)
        run(repeatSpawnAction)
    }
    
    func spawnRandomFallingBall() {
        let ballColors = ["RedBall", "GreenBall", "BlueBall"]
        let randomBallColor = ballColors.randomElement()!
        
        let fallingBallNode = SKSpriteNode(imageNamed: randomBallColor)
        fallingBallNode.size = CGSize(width: 45, height: 45)
        
        let randomButtonPosition: CGFloat = [redLaunchBallButtonNode.position.x, greenLaunchBallButtonNode.position.x, blueLaunchBallButtonNode.position.x].randomElement()!
        fallingBallNode.position = CGPoint(x: randomButtonPosition, y: size.height)

        fallingBallNode.physicsBody = SKPhysicsBody(circleOfRadius: fallingBallNode.size.width / 2)
        fallingBallNode.physicsBody?.affectedByGravity = false
        fallingBallNode.name = randomBallColor
        
        fallingBallNode.physicsBody?.categoryBitMask = PhysicsCategory.FallingBall
        fallingBallNode.physicsBody?.contactTestBitMask = PhysicsCategory.LaunchBall
        fallingBallNode.physicsBody?.collisionBitMask = 0
        
        let moveDownAction = SKAction.moveBy(x: 0, y: -size.height, duration: 5.0)
        let removeAction = SKAction.removeFromParent()
        fallingBallNode.run(SKAction.sequence([moveDownAction, removeAction]))
        
        addChild(fallingBallNode)
    }
    override func update(_ currentTime: TimeInterval) {
        checkForBallCollisions()
    }

    func checkForBallCollisions() {
        for node in children {
            if let launchedBallNode = node as? SKSpriteNode, ["RedBall", "GreenBall", "BlueBall"].contains(launchedBallNode.name) {
                for otherNode in children {
                    if let fallingBallNode = otherNode as? SKSpriteNode, ["RedBall", "GreenBall", "BlueBall"].contains(fallingBallNode.name) {
                        if launchedBallNode != fallingBallNode {
                            if launchedBallNode.frame.intersects(fallingBallNode.frame) {
                                if launchedBallNode.name == fallingBallNode.name {
                                    handleCollisionBetweenLaunchBallAndFallingBallWithCollisionCount()
                                    launchedBallNode.removeFromParent()
                                    fallingBallNode.removeFromParent()
                                }
                            }
                        }
                    }
                }
            }
        }
        for node in children {
            if let fallingBallNode = node as? SKSpriteNode, ["RedBall", "GreenBall", "BlueBall"].contains(fallingBallNode.name) {
                if fallingBallNode.position.y < yPos + 50 {
                    stopGameAndPresentGameOverController()
                }
            }
        }
    }
    
    func stopGameAndPresentGameOverController() {
        isPaused = true
        if collisionCount >= targetcollisionCount {
            gameplayViewController?.processGameCompletionAndGameOverScreen(collisionCount: collisionCount, mainImageForController: "TextWin")
        } else {
            gameplayViewController?.processGameCompletionAndGameOverScreen(collisionCount: collisionCount, mainImageForController: "TextLose")
        }
    }
    
    func restartGame() {
        collisionCount = 0
        collisionCountLabel.text = "\(collisionCount)"
        
        for node in children {
            if let ballNode = node as? SKSpriteNode, ballNode.name?.contains("Ball") == true {
                ballNode.removeFromParent()
            }
        }
        
        isPaused = false
    }
    
    func unPause() {
        isPaused = false
    }
    
    func Pause() {
        isPaused = true
    }
    
    func handleCollisionBetweenLaunchBallAndFallingBallWithCollisionCount() {
        if  UserDefaults.standard.bool(forKey: "isSoundTrue") {
            guard let url = Bundle.main.url(forResource: "score", withExtension: "wav") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
        collisionCount += 1
        gameplayViewController?.updateScoreForGame()
        collisionCountLabel.text = "\(collisionCount)"
        if collisionCount >= targetcollisionCount {
            stopGameAndPresentGameOverController()
        }
    }

}

struct PhysicsCategory {
    static let LaunchBall: UInt32 = 0x1 << 0
    static let FallingBall: UInt32 = 0x1 << 1
}
