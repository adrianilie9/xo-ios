//
//  GameViewController.swift
//  XO
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    enum GameMode {
        case AI
        case Human
    }
    
    public var mode: GameMode = GameMode.AI
    
    @IBOutlet weak var buttonMenuView: UIView!
    @IBOutlet weak var buttonMenuBackgroundImageView: UIImageView!
    @IBOutlet weak var buttonMenuLabel: UILabel!
    
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
        
        self.infoLabel.text = ""
        self.infoLabel.font = UIFont.init(name: UISettings.sharedInstance.font1Regular, size: 20.0)
        self.infoLabel.textColor = UIColor.black
        self.infoLabel.alpha = 0.0
    }
    
    func hideUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.buttonMenuView.alpha = 0.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    func showUi(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.buttonMenuView.alpha = 1.0
        }) { (finished: Bool) in
            completionHandler?()
        }
    }
    
    // MARK: - Content
    
    public func displayInfo(info: String) {
        self.infoLabel.text = info
        
        UIView.animate(withDuration: 0.15, animations: {
            self.infoLabel.alpha = 1.0
        }) { (completed: Bool) in
            if (completed) {
                UIView.animate(withDuration: 2.0, animations: {
                    self.infoLabel.alpha = 0.0
                })
            }
        }
    }
    
    // MARK: - Scene
    
    func prepareScene() {
        var players = Array<Player>()
        players.append(Player.init(type: .Human))
        
        if (self.mode == .AI) {
            players.append(Player.init(type: .AI))
        } else if (self.mode == .Human) {
            players.append(Player.init(type: .Human))
        }
        
        self.gameScene = GameScene.init(
            size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 100.0),
            players: players,
            viewController: self
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
