import UIKit
import SpriteKit
import GameplayKit
import AVFAudio

class GameplayViewController: UIViewController {
    
    weak var sceneGame: LimoChaser?
    
    var toMenu: (() -> ())?
    
    let balanceLabel = UILabel()
    
    private let userBalanceKey = "userBalance"
    private var userBalance: Int {
        get {
            return UserDefaults.standard.integer(forKey: userBalanceKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userBalanceKey)
        }
    }
    
    private var buttonStatusArray: [Bool] {
        get {
            return UserDefaults.standard.array(forKey: "buttonStatusArray") as? [Bool] ?? [true, false, false, false, false, false, false, false, false, false, false, false]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "buttonStatusArray")
        }
    }
    
    var playerAudio: AVAudioPlayer?
    
    let listLevelTargetCollisionCount = [5,10,15,20,25,30,35,40,45,50,55,60]
    
    var nowLevel = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        
        if let viewGame = self.view as? SKView {
            let openLimoChaser = LimoChaser(size: viewGame.bounds.size)
            self.sceneGame = openLimoChaser
            openLimoChaser.gameplayViewController = self
            openLimoChaser.targetcollisionCount = listLevelTargetCollisionCount[nowLevel]
            openLimoChaser.scaleMode = .aspectFill
            viewGame.presentScene(openLimoChaser)
            
        }
        
        configureSetingsButtonForDismissingViewController()
        configureUserBalanceLabel()

    }
    
    private func configureSetingsButtonForDismissingViewController() {
        let closeButton = createSettingsButtonForDismissingViewController()
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
    }
    
    private func createSettingsButtonForDismissingViewController() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "SettingsSoundsAndVibroButton"), for: .normal)
        button.addTarget(self, action: #selector(toGameAudioConfigurationController), for: .touchUpInside)
        addButtonSound(button: button)
        return button
    }
    
    @objc private func toGameAudioConfigurationController() {
        let gameAudioConfigurationController = GameAudioConfigurationController()
        sceneGame?.Pause()
        gameAudioConfigurationController.toMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.toMenu?()
        }
        gameAudioConfigurationController.toBack = { [weak self] in
            self?.sceneGame?.unPause()
        }
        gameAudioConfigurationController.modalPresentationStyle = .overCurrentContext
        self.present(gameAudioConfigurationController, animated: true)
    }
    
    private func configureUserBalanceLabel() {
        balanceLabel.text = "\(userBalance)"
        balanceLabel.font = UIFont(name: "Questrian", size: 20)
        balanceLabel.textColor = .white
        balanceLabel.textAlignment = .center
        
        let backgroundPointsImageView = UIImageView()
        backgroundPointsImageView.image = UIImage(named: "BackGroundPoints")
        
        view.addSubview(backgroundPointsImageView)
        view.addSubview(balanceLabel)
        
        backgroundPointsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.center.equalTo(backgroundPointsImageView)
        }
    }
    
    func end() {
        if UserDefaults.standard.bool(forKey: "isSoundTrue") {
            guard let url = Bundle.main.url(forResource: "end", withExtension: "wav") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
    }
    
    func processGameCompletionAndGameOverScreen(collisionCount: Int, mainImageForController: String) {
        end()
        if collisionCount > UserDefaults.standard.integer(forKey: "BestScore") {
            UserDefaults.standard.set(collisionCount, forKey: "BestScore")
        }
        if mainImageForController == "TextWin" {
            updateLevelCompletedListForGame()
        }
        let endGameplayViewController = EndGameplayViewController()
        endGameplayViewController.toMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.toMenu?()
        }
        endGameplayViewController.restartLimo = { [weak self] in
            self?.sceneGame?.restartGame()
        }
        
        endGameplayViewController.collisionCount = collisionCount
        endGameplayViewController.mainImageForController = mainImageForController
        endGameplayViewController.modalPresentationStyle = .overCurrentContext
        self.present(endGameplayViewController, animated: true)
    }
    
    func updateScoreForGame(){
        UserDefaults.standard.set(1+UserDefaults.standard.integer(forKey: userBalanceKey), forKey: userBalanceKey)
        balanceLabel.text = "\(userBalance)"
    }
    
    func updateLevelCompletedListForGame() {
        
        var levelCompletionStates = buttonStatusArray
        if nowLevel < levelCompletionStates.count {
            levelCompletionStates[nowLevel] = true
            if nowLevel + 1 < levelCompletionStates.count {
                levelCompletionStates[nowLevel + 1] = true
            }
            buttonStatusArray = levelCompletionStates
        }
    }


}
