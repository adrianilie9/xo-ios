//
//  MenuViewController.swift
//  XO
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var buttonPlayAIView: UIView!
    @IBOutlet weak var buttonPlayAIBackgroundImageView: UIImageView!
    @IBOutlet weak var buttonPlayAILabel: UILabel!
    @IBOutlet weak var buttonPlayHumanView: UIView!
    @IBOutlet weak var buttonPlayHumanBackgroundImageView: UIImageView!
    @IBOutlet weak var buttonPlayHumanLabel: UILabel!
    @IBOutlet weak var labelCopyright: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showUi(completionHandler: nil)
    }
    
    // MARK: - UI
    
    override var prefersStatusBarHidden: Bool {
        return !NXUIDeviceDetector.IS_IPHONE_X()
    }
    
    func setupUi() {
        self.labelCopyright.text = "Copyright \u{00A9} Adrian Ilie 2018"
        self.labelCopyright.font = UIFont.init(name: UISettings.sharedInstance.font2Regular, size: 18.0)
        
        // setting up play AI button
        self.buttonPlayAIBackgroundImageView.image = UIImage.init(named: "Button_Play_Default")
        let playAIButtonText = NSMutableAttributedString.init(string: "\u{f233} Play vs. AI")
        playAIButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: UISettings.sharedInstance.fontFontAwesomeSolid, size: 22.0)!], range: NSMakeRange(0, 1))
        playAIButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: UISettings.sharedInstance.font1Bold, size: 20.0)!], range: NSMakeRange(1, playAIButtonText.length - 1))
        self.buttonPlayAILabel.attributedText = playAIButtonText
        
        let tapPlayAIButton = UITapGestureRecognizer.init(target: self, action: #selector(self.startGameAction(sender:)))
        tapPlayAIButton.numberOfTapsRequired = 1
        self.buttonPlayAIView.addGestureRecognizer(tapPlayAIButton)
        self.buttonPlayAIView.tag = 0
        
        // setting up play human button
        self.buttonPlayHumanBackgroundImageView.image = UIImage.init(named: "Button_Play_Default")
        let playHumanButtonText = NSMutableAttributedString.init(string: "\u{f0c0} Play vs. Human")
        playHumanButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: UISettings.sharedInstance.fontFontAwesomeSolid, size: 20.0)!], range: NSMakeRange(0, 1))
        playHumanButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: UISettings.sharedInstance.font1Bold, size: 20.0)!], range: NSMakeRange(1, playHumanButtonText.length - 1))
        self.buttonPlayHumanLabel.attributedText = playHumanButtonText
        
        let tapPlayHumanButton = UITapGestureRecognizer.init(target: self, action: #selector(self.startGameAction(sender:)))
        tapPlayHumanButton.numberOfTapsRequired = 1
        self.buttonPlayHumanView.addGestureRecognizer(tapPlayHumanButton)
        self.buttonPlayHumanView.tag = 1
    }
    
    func showUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.logoImageView.alpha = 1.0
            self.buttonPlayAIView.alpha = 1.0
            self.buttonPlayHumanView.alpha = 1.0
            self.labelCopyright.alpha = 1.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    func hideUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.logoImageView.alpha = 0.0
            self.buttonPlayAIView.alpha = 0.0
            self.buttonPlayHumanView.alpha = 0.0
            self.labelCopyright.alpha = 0.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    // MARK: - Content
    
    func setupContent() {
        
    }
    
    // MARK: - Navigation
    
    @objc func startGameAction(sender: Any?) {
        let gameViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        if let sender = sender as? UITapGestureRecognizer {
            if (sender.view?.tag == self.buttonPlayAIView.tag) {
                gameViewController.mode = GameViewController.GameMode.AI
                self.buttonPlayAIBackgroundImageView.image = UIImage.init(named: "Button_Play_Touched")
            } else if (sender.view?.tag == self.buttonPlayHumanView.tag) {
                gameViewController.mode = GameViewController.GameMode.Human
                self.buttonPlayHumanBackgroundImageView.image = UIImage.init(named: "Button_Play_Touched")
            }
        }
        
        self.hideUi {
            self.buttonPlayAIBackgroundImageView.image = UIImage.init(named: "Button_Play_Default")
            self.buttonPlayHumanBackgroundImageView.image = UIImage.init(named: "Button_Play_Default")
            self.present(gameViewController, animated: false, completion: nil)
        }
    }
}
