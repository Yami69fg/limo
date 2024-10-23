import UIKit
import SnapKit

class GameShopController: UIViewController {
    
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
    
    private let magicaButton = UIButton(type: .custom)
    private let aquamButton = UIButton(type: .custom)
    private let bumbleButton = UIButton(type: .custom)
    
    private let priceForMagicaBackground = 25
    private let priceForAquamBackground = 50
    private let priceForBumbleBackground = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageViewForMainMenu()
        configureUserBalanceLabel()
        configureCloseButtonForDismissingViewController()
        setupShopButtons()
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
    
    private func setupShopButtons() {
            setupMagicaButton()
            setupAquamButton()
            setupBumbleButton()
        }
        
        private func setupMagicaButton() {
            magicaButton.setImage(UIImage(named: "Bumble"), for: .normal)
            magicaButton.addTarget(self, action: #selector(handleMagicaPurchase), for: .touchUpInside)
            addButtonSound(button: magicaButton)
            view.addSubview(magicaButton)
            
            magicaButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(130)
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalToSuperview().multipliedBy(0.25)
            }
        }
        
        private func setupAquamButton() {
            aquamButton.setImage(UIImage(named: "Aquam"), for: .normal)
            aquamButton.addTarget(self, action: #selector(handleAquamPurchase), for: .touchUpInside)
            addButtonSound(button: aquamButton)
            view.addSubview(aquamButton)
            
            aquamButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(magicaButton.snp.bottom).offset(10)
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalToSuperview().multipliedBy(0.25)
            }
        }
        
        private func setupBumbleButton() {
            bumbleButton.setImage(UIImage(named: "Magica"), for: .normal)
            bumbleButton.addTarget(self, action: #selector(handleBumblePurchase), for: .touchUpInside)
            addButtonSound(button: bumbleButton)
            view.addSubview(bumbleButton)
            
            bumbleButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(aquamButton.snp.bottom).offset(10)
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalToSuperview().multipliedBy(0.25)
                
            }
        }

        @objc private func handleMagicaPurchase() {
            executePurchase(backgroundName: "BackGroundBumble", cost: priceForMagicaBackground)
        }

        @objc private func handleAquamPurchase() {
            executePurchase(backgroundName: "BackGroundAquam", cost: priceForAquamBackground)
        }

        @objc private func handleBumblePurchase() {
            executePurchase(backgroundName: "BackGroundMagica", cost: priceForBumbleBackground)
        }

    private func executePurchase(backgroundName: String, cost: Int) {
        let currentScore = UserDefaults.standard.integer(forKey: userBalanceKey)
        let ownedBackgrounds = UserDefaults.standard.array(forKey: "PurchasedBackgrounds") as? [String] ?? []
        
        if ownedBackgrounds.contains(backgroundName) {
            displayMessage("\(backgroundName) background is applied!")
        } else if currentScore >= cost {
            confirmPurchase(backgroundName: backgroundName, cost: cost) {
                self.completePurchase(backgroundName: backgroundName, cost: cost)
            }
        } else {
            displayMessage("Insufficient balance of \(cost) to buy \(backgroundName) background.")
        }
    }

    private func confirmPurchase(backgroundName: String, cost: Int, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Confirm",
                                      message: "You can buy \(backgroundName) for \(cost) points. Would you like to proceed?",
                                      preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func completePurchase(backgroundName: String, cost: Int) {
        var currentScore = UserDefaults.standard.integer(forKey: userBalanceKey)
        currentScore -= cost
        UserDefaults.standard.set(currentScore, forKey: userBalanceKey)

        var ownedBackgrounds = UserDefaults.standard.array(forKey: "PurchasedBackgrounds") as? [String] ?? []
        ownedBackgrounds.append(backgroundName)
        UserDefaults.standard.set(ownedBackgrounds, forKey: "PurchasedBackgrounds")

        balanceLabel.text = "\(currentScore)"
        displayMessage("\(backgroundName) background successfully!") {
            self.applyBackgroundImage(backgroundName: backgroundName)
        }
    }

    private func applyBackgroundImage(backgroundName: String) {
        UserDefaults.standard.set(backgroundName, forKey: "CurrentBackground")
        displayMessage("\(backgroundName) has been set!")
    }

    private func displayMessage(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
