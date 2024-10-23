import UIKit
import SnapKit

class EndGameplayViewController: UIViewController {
    
    var collisionCount = 0
    var mainImageForController = ""
    
    var toMenu: (() -> ())?
    
    var restartLimo: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageView()
        configureOtherBackgroundImageViewForButtons()
        configureTextImageView()
        configureMenuButtonForDismissingViewController()
        configureResetButtonForDismissingViewController()
        configureScoreTextImageView()
        configureBestScoreTextImageView()
    }
    
    private func configureBackgroundImageView() {
        let backgroundImageView = createBackgroundImageView()
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createBackgroundImageView() -> UIImageView {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "BackGroundShadow")
        return backgroundImageView
    }
    
    private func configureOtherBackgroundImageViewForButtons() {
        let otherBackgroundImageView = createOtherBackgroundImageView()
        otherBackgroundImageView.isUserInteractionEnabled = true
        view.addSubview(otherBackgroundImageView)
        
        otherBackgroundImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(otherBackgroundImageView.snp.width).multipliedBy(0.75)
        }
    }
    
    private func createOtherBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "OtherBackGround")
        return imageView
    }
    
    private func configureTextImageView() {
        let levelsTextImageView = createTextImageView()
        view.addSubview(levelsTextImageView)
        
        levelsTextImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.subviews[1].snp.top).offset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(250)
        }
    }
    
    private func createTextImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: mainImageForController)
        return imageView
    }
    
    private func configureMenuButtonForDismissingViewController() {
        let menuButton = createMenuButtonForDismissingViewController()
        view.addSubview(menuButton)
        
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(view.subviews[1].snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    private func createMenuButtonForDismissingViewController() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "AdvanceToMenu"), for: .normal)
        button.addTarget(self, action: #selector(dismissViewControllerToMenu), for: .touchUpInside)
        addButtonSound(button: button)
        return button
    }
    
    @objc private func dismissViewControllerToMenu() {
        dismiss(animated: true, completion: nil)
        toMenu?()
    }
    
    private func configureResetButtonForDismissingViewController() {
        let resetButton = createResetButtonForDismissingViewController()
        view.addSubview(resetButton)
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(view.subviews[1].snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(205)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    private func createResetButtonForDismissingViewController() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "AdvanceToResetGame"), for: .normal)
        button.addTarget(self, action: #selector(dismissViewControllerToReset), for: .touchUpInside)
        addButtonSound(button: button)
        return button
    }
    
    @objc private func dismissViewControllerToReset() {
        dismiss(animated: true, completion: nil)
        restartLimo?()
    }
    
    private func createScoreTitleLabelWithIndex() -> UILabel {
        let label = UILabel()
        label.text = "Score: \(collisionCount)"
        label.font = UIFont(name: "Questrian", size: 32)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func configureScoreTextImageView() {
        let levelsTextImageView = createScoreTitleLabelWithIndex()
        view.addSubview(levelsTextImageView)
        
        levelsTextImageView.snp.makeConstraints { make in
            make.left.equalTo(view.subviews[1].snp.left).offset(10)
            make.centerY.equalTo(view.subviews[1].snp.centerY).offset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(75)
        }
    }
    
    private func createBestScoreTitleLabelWithIndex() -> UILabel {
        let label = UILabel()
        label.text = "Best Score: \(UserDefaults.standard.integer(forKey: "BestScore"))"
        label.font = UIFont(name: "Questrian", size: 32)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func configureBestScoreTextImageView() {
        let levelsTextImageView = createBestScoreTitleLabelWithIndex()
        view.addSubview(levelsTextImageView)
        
        levelsTextImageView.snp.makeConstraints { make in
            make.left.equalTo(view.subviews[1].snp.left).offset(10)
            make.centerY.equalTo(view.subviews[1].snp.centerY).offset(-30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(75)
        }
    }
}
