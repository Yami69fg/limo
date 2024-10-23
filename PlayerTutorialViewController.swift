import UIKit
import SnapKit

class PlayerTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageViewForMainMenu()
        configureCloseButtonForDismissingViewController()
        configureOtherBackgroundImageViewForButtons()
        configureInstructionTextImageView()
        configureMultilineAutoSizingTextLabel()
    }
    
    private func configureBackgroundImageViewForMainMenu() {
        let backgroundImageViewForMainMenu = createBackgroundImageViewForMainMenu()
        view.addSubview(backgroundImageViewForMainMenu)
        
        backgroundImageViewForMainMenu.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createBackgroundImageViewForMainMenu() -> UIImageView {
        let backgroundImageViewForMainMenu = UIImageView()
        backgroundImageViewForMainMenu.image = UIImage(named: "BlurBackGroundForApp")
        backgroundImageViewForMainMenu.contentMode = .scaleAspectFill
        return backgroundImageViewForMainMenu
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
    
    private func createOtherBackgroundImageView() -> UIImageView {
        let otherBackgroundImageViewForButtons = UIImageView()
        otherBackgroundImageViewForButtons.image = UIImage(named: "OtherBackGround")
        return otherBackgroundImageViewForButtons
    }
    
    private func configureOtherBackgroundImageViewForButtons() {
        let otherBackgroundImageViewForButtons = createOtherBackgroundImageView()
        otherBackgroundImageViewForButtons.isUserInteractionEnabled = true
        view.addSubview(otherBackgroundImageViewForButtons)
        
        otherBackgroundImageViewForButtons.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(otherBackgroundImageViewForButtons.snp.width).multipliedBy(0.9)
        }
    }
    
    private func createInstructionTextImageView() -> UIImageView {
        let instructionTextImageViewForButtons = UIImageView()
        instructionTextImageViewForButtons.image = UIImage(named: "TextInstruction")
        return instructionTextImageViewForButtons
    }
    
    private func configureInstructionTextImageView() {
        let instructionTextImageViewForButtons = createInstructionTextImageView()
        view.addSubview(instructionTextImageViewForButtons)
        
        instructionTextImageViewForButtons.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.subviews[2].snp.top).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(75)
        }
    }
    
    private func configureMultilineAutoSizingTextLabel() {
        let multilineAutoSizingTextLabel = UILabel()
        multilineAutoSizingTextLabel.text = "To complete the level, you need to score a certain number of points. Every 5 seconds, a ball with a random color falls, and you need to choose the correct color to shoot and hit the ball. If the colors match, the ball is removed. If not, it passes through. When the falling ball reaches the boundary, the game ends."
        multilineAutoSizingTextLabel.numberOfLines = 0
        multilineAutoSizingTextLabel.textAlignment = .center
        multilineAutoSizingTextLabel.textColor = .white
        multilineAutoSizingTextLabel.font = UIFont(name: "Questrian", size: 32)
        multilineAutoSizingTextLabel.adjustsFontSizeToFitWidth = true
        multilineAutoSizingTextLabel.minimumScaleFactor = 0.5

        view.subviews[2].addSubview(multilineAutoSizingTextLabel)
        
        multilineAutoSizingTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(multilineAutoSizingTextLabel.snp.width).multipliedBy(0.9)
        }
    }
    
    @objc private func dismissViewControllerToBack() {
        dismiss(animated: true, completion: nil)
    }
}
