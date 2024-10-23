import UIKit
import SnapKit

class LoadingScreenViewController: UIViewController {
    
    private var ballImageOptions = ["BlueBall", "RedBall", "GreenBall", "PinkBall"]
    private var currentBallIndex = 0
    private var ballTransitionTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        setupBouncingBallImageView()
        setupLoadingTextImageView()
        
        initiateBallTransitionAnimation()
        setupLoadingTextAnimation()
        proceedToNextScreenAfterDelay()
    }
    
    private func setupBackgroundImageView() {
        let backgroundImageView = createBackgroundImageView()
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBouncingBallImageView() {
        let bouncingBallImageView = createBouncingBallImageView()
        view.addSubview(bouncingBallImageView)
        
        bouncingBallImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.height.equalTo(200)
        }
    }
    
    private func setupLoadingTextImageView() {
        let loadingTextImageView = createLoadingTextImageView()
        view.addSubview(loadingTextImageView)
        
        loadingTextImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.subviews[1].snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    private func createBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BlurBackGroundForApp")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    private func createBouncingBallImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PinkBall")
        return imageView
    }
    
    private func createLoadingTextImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TextLoading")
        return imageView
    }
    
    private func initiateBallTransitionAnimation() {
        let bouncingBallImageView = view.subviews[1] as! UIImageView
        
        ballTransitionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.currentBallIndex = (self.currentBallIndex + 1) % self.ballImageOptions.count
            let nextBallImage = self.ballImageOptions[self.currentBallIndex]
            
            UIView.transition(with: bouncingBallImageView, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                bouncingBallImageView.image = UIImage(named: nextBallImage)
            }, completion: nil)
        }
    }
    
    private func setupLoadingTextAnimation() {
        let loadingTextImageView = view.subviews[2] as! UIImageView
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            loadingTextImageView.alpha = 0.0
        }, completion: { finished in
            loadingTextImageView.alpha = 1.0
        })
    }
    
    private func stopBallTransitionAnimation() {
        ballTransitionTimer?.invalidate()
        ballTransitionTimer = nil
    }
    
    private func proceedToNextScreenAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.stopBallTransitionAnimation()
            let nextScreenController = GameNavigationMenuController()
            nextScreenController.modalTransitionStyle = .crossDissolve
            nextScreenController.modalPresentationStyle = .fullScreen
            self.present(nextScreenController, animated: false, completion: nil)
        }
    }
}
