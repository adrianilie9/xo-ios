//
//  MenuViewController.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit

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
        
    }
    
    // MARK: - Content
    
    func setupContent() {
        
    }
}
