import UIKit
import SnapKit

class GameNavigationMenuController: UIViewController {
    
    var toMenu: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageViewForMainMenu()
        configurePinkBallWithCenterIcon()
        configureGameButtonWithIcon()
        configureStoreButtonWithIcon()
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
    
    private func configurePinkBallWithCenterIcon() {
        let pinkBallImageView = createPinkBallWithCenterIcon()
        view.addSubview(pinkBallImageView)
        
        pinkBallImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalToSuperview().multipliedBy(0.65)
            make.height.equalTo(pinkBallImageView.snp.width)
        }
    }
    
    private func createPinkBallWithCenterIcon() -> UIImageView {
        let pinkBallImageView = UIImageView()
        pinkBallImageView.image = UIImage(named: "PinkBall")
        
        let centerIconImageView = UIImageView(image: UIImage(named: "TextMain"))
        
        pinkBallImageView.addSubview(centerIconImageView)
        centerIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(pinkBallImageView.snp.width).multipliedBy(0.9)
            make.height.equalTo(pinkBallImageView.snp.height).multipliedBy(0.75)
        }
        
        return pinkBallImageView
    }
    
    private func configureGameButtonWithIcon() {
        let gameButton = createButtonWithIcon(imageName: "AdvanceToGame")
        gameButton.addTarget(self, action: #selector(transitionToGameViewController), for: .touchUpInside)
        addButtonSound(button: gameButton)
        view.addSubview(gameButton)
        
        gameButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.subviews[1].snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalTo(75)
        }
    }
    
    private func configureStoreButtonWithIcon() {
        let storeButton = createButtonWithIcon(imageName: "AdvanceToStore")
        storeButton.addTarget(self, action: #selector(transitionToStoreViewController), for: .touchUpInside)
        addButtonSound(button: storeButton)
        view.addSubview(storeButton)
        
        storeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.subviews[2].snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalTo(75)
        }
    }
    
    private func createButtonWithIcon(imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }
    
    @objc private func transitionToGameViewController() {
        let gameViewController = GameStagesViewController()
        gameViewController.toMenu = { [weak self] in
            self?.dismiss(animated: false)
        }
        gameViewController.modalTransitionStyle = .crossDissolve
        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: true, completion: nil)
    }

    @objc private func transitionToAchievementsViewController() {
        let achievementsViewController = PlayerAchievementsViewController()
        achievementsViewController.modalTransitionStyle = .crossDissolve
        achievementsViewController.modalPresentationStyle = .fullScreen
        present(achievementsViewController, animated: true, completion: nil)
    }

    @objc private func transitionToStoreViewController() {
        let storeViewController = GameShopController()
        storeViewController.modalTransitionStyle = .crossDissolve
        storeViewController.modalPresentationStyle = .fullScreen
        present(storeViewController, animated: true, completion: nil)
    }
}
