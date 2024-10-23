import UIKit
import SpriteKit
import AVFoundation

class AddSound {
    
    static let shared = AddSound()
    private var audio: AVAudioPlayer?

    private init() {}
    
    func playSoundPress() {
        let isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundTrue")
        if isSoundEnabled {
            guard let sound = Bundle.main.url(forResource: "button", withExtension: "wav") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
        
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "isVibroTrue")
        if isVibrationEnabled {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        }
    }
}



extension UIViewController {
    
    func addButtonSound(button: UIButton) {
        button.addTarget(self, action: #selector(handleButtonTouchDown(sender:)), for: .touchDown)
    }
    
    @objc private func handleButtonTouchDown(sender: UIButton) {
        AddSound.shared.playSoundPress()
    }
}
