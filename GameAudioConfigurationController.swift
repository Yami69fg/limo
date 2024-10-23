import UIKit
import SpriteKit
import GameplayKit
import SnapKit

class GameAudioConfigurationController: UIViewController {
    
    var toMenu: (() -> ())?
    var toBack: (() -> ())?
    
    var buttonForSound = UIButton()
    var buttonForVibration = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageView()
        configureOtherBackgroundImageViewForButtons()
        configureTextImageView()
        configureMenuButtonForDismissingViewController()
        configureResetButtonForDismissingViewController()
        configureSoundTextImageView()
        configureVibrationTextImageView()
        configureSoundButton()
        configureVibrationButton()
        
        loadUserSettingsState()
        
        buttonForSound.addTarget(self, action: #selector(targSoundSetting), for: .touchUpInside)
        addButtonSound(button: buttonForSound)
        buttonForVibration.addTarget(self, action: #selector(targVibrationSetting), for: .touchUpInside)
        addButtonSound(button: buttonForVibration)
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
            make.height.equalTo(200)
        }
    }
    
    private func createTextImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TextSettings")
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
        button.setImage(UIImage(named: "AdvanceToBack"), for: .normal)
        button.addTarget(self, action: #selector(dismissViewControllerToBack), for: .touchUpInside)
        addButtonSound(button: button)
        return button
    }
    
    @objc private func dismissViewControllerToBack() {
        dismiss(animated: true)
        toBack?()
    }
    
    private func createSoundTitleLabelWithIndex() -> UILabel {
        let label = UILabel()
        label.text = "Sound"
        label.font = UIFont(name: "Questrian", size: 28)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func configureSoundTextImageView() {
        let soundLabel = createSoundTitleLabelWithIndex()
        view.addSubview(soundLabel)
        
        soundLabel.snp.makeConstraints { make in
            make.left.equalTo(view.subviews[1].snp.left).offset(50)
            make.centerY.equalTo(view.subviews[1].snp.centerY).offset(30)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(75)
        }
    }
    
    private func createVibrationTitleLabelWithIndex() -> UILabel {
        let label = UILabel()
        label.text = "Vibration"
        label.font = UIFont(name: "Questrian", size: 28)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func configureVibrationTextImageView() {
        let vibrationLabel = createVibrationTitleLabelWithIndex()
        view.addSubview(vibrationLabel)
        
        vibrationLabel.snp.makeConstraints { make in
            make.left.equalTo(view.subviews[1].snp.left).offset(60)
            make.centerY.equalTo(view.subviews[1].snp.centerY).offset(-30)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(75)
        }
    }
    
    private func createSoundButton() -> UIButton {
        buttonForSound.translatesAutoresizingMaskIntoConstraints = false
        return buttonForSound
    }
    
    private func configureSoundButton() {
        let soundButton = createSoundButton()
        view.addSubview(soundButton)
        
        soundButton.snp.makeConstraints { make in
            make.left.equalTo(view.subviews[3].snp.right).offset(50)
            make.centerY.equalTo(view.subviews[1].snp.centerY).offset(30)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.height.equalTo(50)
        }
    }
    
    private func createVibrationButton() -> UIButton {
        buttonForVibration.translatesAutoresizingMaskIntoConstraints = false
        return buttonForVibration
    }
    
    private func configureVibrationButton() {
        let vibrationButton = createVibrationButton()
        view.addSubview(vibrationButton)
        
        vibrationButton.snp.makeConstraints { make in
            make.left.equalTo(view.subviews[3].snp.right).offset(100)
            make.centerY.equalTo(view.subviews[1].snp.centerY).offset(-30)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.height.equalTo(50)
        }
    }
    
    private func configureDefaultUserSettings() {
        if UserDefaults.standard.object(forKey: "isSoundTrue") == nil {
            UserDefaults.standard.set(true, forKey: "isSoundTrue")
        }
        if UserDefaults.standard.object(forKey: "isVibrationTrue") == nil {
            UserDefaults.standard.set(true, forKey: "isVibrationTrue")
        }
    }

    private func loadUserSettingsState() {
        let isSoundActive = UserDefaults.standard.bool(forKey: "isSoundTrue")
        let isVibrationActive = UserDefaults.standard.bool(forKey: "isVibrationTrue")

        buttonForSound.setImage(UIImage(named: isSoundActive ? "On" : "Off"), for: .normal)
        buttonForVibration.setImage(UIImage(named: isVibrationActive ? "On" : "Off"), for: .normal)
    }

    @objc private func targSoundSetting() {
        let currentSoundState = buttonForSound.currentImage == UIImage(named: "On")
        let newSoundState = !currentSoundState
        buttonForSound.setImage(UIImage(named: newSoundState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newSoundState, forKey: "isSoundTrue")
    }

    @objc private func targVibrationSetting() {
        let currentVibrationState = buttonForVibration.currentImage == UIImage(named: "On")
        let newVibrationState = !currentVibrationState
        buttonForVibration.setImage(UIImage(named: newVibrationState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newVibrationState, forKey: "isVibrationTrue")
    }
}
