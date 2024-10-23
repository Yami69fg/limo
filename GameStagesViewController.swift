import UIKit
import SnapKit

class GameStagesViewController: UIViewController {
    
    var toMenu: (() -> ())?

    private let buttonStatusKey = "buttonStatusArray"
    private var buttonStatusArray: [Bool] {
        get {
            return UserDefaults.standard.array(forKey: buttonStatusKey) as? [Bool] ?? [true, false, false, false, false, false, false, false, false, false, false, false]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: buttonStatusKey)
        }
    }
    
    private let userBalanceKey = "userBalance"
    private var userBalance: Int {
        get {
            return UserDefaults.standard.integer(forKey: userBalanceKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userBalanceKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageViewForMainMenu()
        configureCloseButtonForDismissingViewController()
        configureOtherBackgroundImageViewForButtons()
        configureLevelButtons()
        configureLevelsTextImageView()
        configureAchievementsButton()
        configureInstructionsButton()
        configureUserBalanceLabel()

        if UserDefaults.standard.array(forKey: buttonStatusKey) == nil {
            buttonStatusArray = [true, false, false, false, false, false, false, false, false, false, false, false]
        }
    }

    private func configureBackgroundImageViewForMainMenu() {
        let backgroundImageView = createBackgroundImageViewForMainMenu()
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createBackgroundImageViewForMainMenu() -> UIImageView {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "BlurBackGroundForApp")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }
    
    private func configureCloseButtonForDismissingViewController() {
        let closeButton = createCloseButtonForDismissingViewController()
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
    }
    
    private func createCloseButtonForDismissingViewController() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "GoToBackButton"), for: .normal)
        button.addTarget(self, action: #selector(dismissViewControllerToBack), for: .touchUpInside)
        addButtonSound(button: button)
        return button
    }
    
    @objc private func dismissViewControllerToBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureOtherBackgroundImageViewForButtons() {
        let otherBackgroundImageView = createOtherBackgroundImageView()
        otherBackgroundImageView.isUserInteractionEnabled = true
        view.addSubview(otherBackgroundImageView)
        
        otherBackgroundImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(otherBackgroundImageView.snp.width).multipliedBy(0.9)
        }
    }
    
    private func createOtherBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "OtherBackGround")
        return imageView
    }
    
    private func configureLevelButtons() {
        let buttonSize: CGFloat = 50
        let padding: CGFloat = 20
        let leftInset: CGFloat = 40
        let topInset: CGFloat = 60
        let columns = 4
        
        for index in 0..<12 {
            let button = createLevelButtonWithIndex(index: index)
            button.tag = index
            let row = index / columns
            let column = index % columns
            
            view.subviews[2].addSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(buttonSize)
                make.top.equalTo(view.subviews[2].snp.top).offset(topInset + (buttonSize + padding) * CGFloat(row))
                make.left.equalTo(view.subviews[2].snp.left).offset(leftInset + (buttonSize + padding) * CGFloat(column))
            }
        }
    }
    
    private func createLevelButtonWithIndex(index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        if buttonStatusArray[index] {
            button.setImage(UIImage(named: "BackGroundForLevelButton"), for: .normal)
            let titleLabel = createLevelTitleLabelWithIndex(index: index)
            button.addSubview(titleLabel)
            button.isUserInteractionEnabled = true
            titleLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        } else {
            button.setImage(UIImage(named: "LockButtonForLevel"), for: .normal)
            button.isUserInteractionEnabled = false
        }
        button.addTarget(self, action: #selector(startLimoChaserGame(_:)), for: .touchUpInside)
        addButtonSound(button: button)
        button.layer.cornerRadius = 10
        return button
    }
    
    @objc func startLimoChaserGame(_ i: UIButton) {
        let startLimoChaserGame = GameplayViewController()
        startLimoChaserGame.toMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.toMenu?()
        }
        startLimoChaserGame.nowLevel = i.tag
        startLimoChaserGame.modalTransitionStyle = .crossDissolve
        startLimoChaserGame.modalPresentationStyle = .fullScreen
        present(startLimoChaserGame, animated: true, completion: nil)
    }
    
    private func createLevelTitleLabelWithIndex(index: Int) -> UILabel {
        let label = UILabel()
        label.text = "\(index + 1)"
        label.font = UIFont(name: "Questrian", size: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func configureLevelsTextImageView() {
        let levelsTextImageView = createLevelsTextImageView()
        view.addSubview(levelsTextImageView)
        
        levelsTextImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.subviews[2].snp.top).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(75)
        }
    }
    
    private func createLevelsTextImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TextLevels")
        return imageView
    }
    
    private func configureAchievementsButton() {
        let achievementsButton = UIButton(type: .custom)
        achievementsButton.setImage(UIImage(named: "AdvanceToAchievement"), for: .normal)
        achievementsButton.addTarget(self, action: #selector(transitionToAchievementsViewController), for: .touchUpInside)
        addButtonSound(button: achievementsButton)
        view.addSubview(achievementsButton)
        
        achievementsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-100)
            make.top.equalTo(view.subviews[2].snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }

    @objc private func transitionToAchievementsViewController() {
        let achievementsViewController = PlayerAchievementsViewController()
        achievementsViewController.modalTransitionStyle = .crossDissolve
        achievementsViewController.modalPresentationStyle = .fullScreen
        present(achievementsViewController, animated: true, completion: nil)
    }

    private func configureInstructionsButton() {
        let instructionsButton = UIButton(type: .custom)
        instructionsButton.setImage(UIImage(named: "AdvanceToInstruction"), for: .normal)
        instructionsButton.addTarget(self, action: #selector(transitionToInstructionsViewController), for: .touchUpInside)
        addButtonSound(button: instructionsButton)
        view.addSubview(instructionsButton)
        
        instructionsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(100)
            make.top.equalTo(view.subviews[2].snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    @objc private func transitionToInstructionsViewController() {
        let instructionsViewController = PlayerTutorialViewController()
        instructionsViewController.modalTransitionStyle = .crossDissolve
        instructionsViewController.modalPresentationStyle = .fullScreen
        present(instructionsViewController, animated: false, completion: nil)
    }
    
    private func configureUserBalanceLabel() {
        let balanceLabel = UILabel()
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
}
