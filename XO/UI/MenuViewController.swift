//
//  MenuViewController.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var buttonPlayView: UIView!
    @IBOutlet weak var buttonPlayBackgroundImageView: UIImageView!
    @IBOutlet weak var buttonPlayLabel: UILabel!
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
        self.buttonPlayBackgroundImageView.image = UIImage.init(named: "Button_Play_Default")
        let playButtonText = NSMutableAttributedString.init(string: "\u{f04b}  Play")
        playButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: UISettings.sharedInstance.fontFontAwesomeSolid, size: 30.0)!], range: NSMakeRange(0, 1))
        playButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: UISettings.sharedInstance.font1Bold, size: 32.0)!], range: NSMakeRange(1, playButtonText.length - 1))
        self.buttonPlayLabel.attributedText = playButtonText
        
        let tapPlayButton = UITapGestureRecognizer.init(target: self, action: #selector(self.startGameAction))
        tapPlayButton.numberOfTapsRequired = 1
        self.buttonPlayView.addGestureRecognizer(tapPlayButton)
        
        self.labelCopyright.text = "Copyright \u{00A9} Nixiware 2018"
        self.labelCopyright.font = UIFont.init(name: UISettings.sharedInstance.font2Regular, size: 18.0)
    }
    
    func showUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.logoImageView.alpha = 1.0
            self.buttonPlayView.alpha = 1.0
            self.labelCopyright.alpha = 1.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    func hideUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.logoImageView.alpha = 0.0
            self.buttonPlayView.alpha = 0.0
            self.labelCopyright.alpha = 0.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    // MARK: - Content
    
    func setupContent() {
        
    }
    
    // MARK: - Navigation
    
    @objc func startGameAction() {
        self.buttonPlayBackgroundImageView.image = UIImage.init(named: "Button_Play_Touched")
        
        let gameViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController")
        
        self.hideUi {
            self.buttonPlayBackgroundImageView.image = UIImage.init(named: "Button_Play_Default")
            self.present(gameViewController, animated: false, completion: nil)
        }
    }
}
