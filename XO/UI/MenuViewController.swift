//
//  MenuViewController.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit

import os.log

class MenuViewController: UIViewController {
    
    @IBOutlet weak var buttonPlayView: UIView!
    @IBOutlet weak var buttonPlayBackgroundImageView: UIImageView!
    @IBOutlet weak var buttonPlayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUi()
    }
    
    // MARK: - UI
    
    override var prefersStatusBarHidden: Bool {
        return !NXUIDeviceDetector.IS_IPHONE_X()
    }
    
    func setupUi() {
        //"FontAwesome5FreeSolid" "Dosis-Bold"
        let playButtonText = NSMutableAttributedString.init(string: self.buttonPlayLabel.text!)
        playButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: "FontAwesome5FreeSolid", size: 30.0)!], range: NSMakeRange(0, 1))
        playButtonText.setAttributes([NSAttributedStringKey.font: UIFont.init(name: "Dosis-Bold", size: 30.0)!], range: NSMakeRange(1, playButtonText.length - 1))
        self.buttonPlayLabel.attributedText = playButtonText
        
        let tapPlayButton = UITapGestureRecognizer.init(target: self, action: #selector(self.tapBlurButton(_:)))
        tapPlayButton.numberOfTapsRequired = 1
        self.buttonPlayView.addGestureRecognizer(tapPlayButton)
    }
    
    // MARK: - Content
    
    func setupContent() {
        
    }
    
    // MARK: - Navigation
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        
    }
}
