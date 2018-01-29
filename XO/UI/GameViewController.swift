//
//  GameViewController.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var buttonMenuView: UIView!
    @IBOutlet weak var buttonMenuBackgroundImageView: UIImageView!
    @IBOutlet weak var buttonMenuLabel: UILabel!
    
    @IBOutlet weak var countdownIconLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    @IBOutlet weak var sceneView: SKView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    private var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUi()
        self.prepareScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showUi(completionHandler: nil)
        self.loadScene()
    }
    
    // MARK: - UI
    
    override var prefersStatusBarHidden: Bool {
        return !NXUIDeviceDetector.IS_IPHONE_X()
    }
    
    func setupUi() {
        self.buttonMenuBackgroundImageView.image = UIImage.init(named: "Button_Blue_Default")
        let menuButtonText = NSMutableAttributedString.init(string: "\u{f0c9}")
        menuButtonText.setAttributes([
            NSAttributedStringKey.font: UIFont.init(name: UISettings.sharedInstance.fontFontAwesomeSolid, size: 22.0)!,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], range: NSMakeRange(0, 1))
        self.buttonMenuLabel.attributedText = menuButtonText
        
        let tapMenuButton = UITapGestureRecognizer.init(target: self, action: #selector(self.goToMainMenuAction))
        tapMenuButton.numberOfTapsRequired = 1
        self.buttonMenuView.addGestureRecognizer(tapMenuButton)
        
        self.countdownIconLabel.text = "\u{f2f2}"
        self.countdownIconLabel.font = UIFont.init(name: UISettings.sharedInstance.fontFontAwesomeSolid, size: 30.0)
        self.countdownIconLabel.textColor = UIColor.init(red: 90.0/255.0, green: 177.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        
        self.countdownLabel.text = "00:00:00"
        self.countdownLabel.font = UIFont.init(name: UISettings.sharedInstance.font1Bold, size: 25.0)
        self.countdownLabel.textColor = UIColor.init(red: 90.0/255.0, green: 177.0/255.0, blue: 142.0/255.0, alpha: 1.0)
    }
    
    func hideUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.buttonMenuView.alpha = 0.0
            
            self.countdownIconLabel.alpha = 0.0
            self.countdownLabel.alpha = 0.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    func showUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.buttonMenuView.alpha = 1.0
            
            self.countdownIconLabel.alpha = 1.0
            self.countdownLabel.alpha = 1.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    // MARK: - Content
    
    func setupContent() {
        
    }
    
    // MARK: - Scene
    
    func prepareScene() {
        self.gameScene = GameScene.init(
            size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 100.0),
            mode: .PlayerVersusPlayer
        )
    }
    
    func loadScene() {
        self.sceneView.presentScene(self.gameScene)
    }
    
    // MARK: - Navigation
    
    @objc func goToMainMenuAction() {
        self.buttonMenuBackgroundImageView.image = UIImage.init(named: "Button_Blue_Touched")
        
        self.hideUi {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
