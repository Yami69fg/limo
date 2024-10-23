import UIKit
import SnapKit

class PlayerAchievementsViewController: UIViewController {
    
    private let userBalanceKey = "userBalance"
    let balanceLabel = UILabel()
    private var userBalance: Int {
        get {
            return UserDefaults.standard.integer(forKey: userBalanceKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userBalanceKey)
        }
    }
    
    private var achiveStatusArray: [Bool] {
        get {
            return UserDefaults.standard.array(forKey: "achiveStatusArray") as? [Bool] ?? [false, false, false]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "achiveStatusArray")
        }
    }
    
    private let fiftyPointsButton = UIButton(type: .custom)
    private let levelsButton = UIButton(type: .custom)
    private let purhaseButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageViewForMainMenu()
        configureUserBalanceLabel()
        configureCloseButtonForDismissingViewController()
        setupFiftyPointsButton()
        setupLevelsButton()
        setupPurhaseButton()
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
    
    private func createCloseButtonForDismissingViewController() -> UIButton {
        let closeButtonForDismissingViewController = UIButton(type: .custom)
        closeButtonForDismissingViewController.setImage(UIImage(named: "GoToBackButton"), for: .normal)
        closeButtonForDismissingViewController.addTarget(self, action: #selector(dismissViewControllerToBack), for: .touchUpInside)
        addButtonSound(button: closeButtonForDismissingViewController)
        return closeButtonForDismissingViewController
    }
    
    private func configureCloseButtonForDismissingViewController() {
        let closeButtonForDismissingViewController = createCloseButtonForDismissingViewController()
        view.addSubview(closeButtonForDismissingViewController)
        
        closeButtonForDismissingViewController.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
    }
    
    @objc private func dismissViewControllerToBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupFiftyPointsButton() {
        fiftyPointsButton.setImage(UIImage(named: "Fifty"), for: .normal)
        if achiveStatusArray[0] || userBalance >= 50{
            fiftyPointsButton.alpha = 1.0
            achiveStatusArray[0] = true
            UserDefaults.standard.set(achiveStatusArray, forKey: "achiveStatusArray")
        } else {
            fiftyPointsButton.alpha = 0.5
        }
        fiftyPointsButton.addTarget(self, action: #selector(handleFiftyPointsButton), for: .touchUpInside)
        addButtonSound(button: fiftyPointsButton)
        view.addSubview(fiftyPointsButton)
        
        fiftyPointsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(130)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
    
    private func setupLevelsButton() {
        let levels = UserDefaults.standard.array(forKey: "buttonStatusArray") as? [Bool] ?? []
        let levelsCount = levels.filter { $0 == true }.count
        levelsButton.setImage(UIImage(named: "Twelve"), for: .normal)
        if levelsCount >= 12{
            levelsButton.alpha = 1.0
            achiveStatusArray[1] = true
            UserDefaults.standard.set(achiveStatusArray, forKey: "achiveStatusArray")
        } else {
            levelsButton.alpha = 0.5
        }
        levelsButton.addTarget(self, action: #selector(handleLevelsButton), for: .touchUpInside)
        addButtonSound(button: levelsButton)
        view.addSubview(levelsButton)
        
        levelsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fiftyPointsButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
    
    private func setupPurhaseButton() {
        purhaseButton.setImage(UIImage(named: "First"), for: .normal)
        if UserDefaults.standard.array(forKey: "PurchasedBackgrounds")?.count ?? 0 >= 1{
            purhaseButton.alpha = 1.0
            achiveStatusArray[2] = true
            UserDefaults.standard.set(achiveStatusArray, forKey: "achiveStatusArray")
        } else {
            purhaseButton.alpha = 0.5
        }
        purhaseButton.addTarget(self, action: #selector(handlePurhaseButton), for: .touchUpInside)
        addButtonSound(button: purhaseButton)
        view.addSubview(purhaseButton)
        
        purhaseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelsButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.25)
            
        }
    }
    
    @objc private func handleFiftyPointsButton() {
        if achiveStatusArray[0]{
            showAchievementAlert(achievementName: "FiftyPoints")
        }else{
            showDisabledAlert()
        }
        
    }

    @objc private func handleLevelsButton() {
        if achiveStatusArray[1]{
            showAchievementAlert(achievementName: "12 Levels")
        }else{
            showDisabledAlert()
        }
    }

    @objc private func handlePurhaseButton() {
        if achiveStatusArray[2]{
            showAchievementAlert(achievementName: "First Purhase")
        }else{
            showDisabledAlert()
        }
    }
    
    private func showAchievementAlert(achievementName: String) {
        let alert = UIAlertController(title: "Achievement Unlocked", message: "\(achievementName) completed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showDisabledAlert() {
        let alert = UIAlertController(title: "Achievement Locked", message: "This achievement is not yet unlocked.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
