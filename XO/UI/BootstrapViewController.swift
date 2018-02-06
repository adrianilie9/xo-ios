//
//  BootstrapViewController.swift
//  XO
//

import UIKit

import NXUIKitUtil

class BootstrapViewController: UIViewController {
    
    public let kNotificationBootstrapCompleted = Notification.Name("BootstrapViewController_BootstrapCompleted")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performBootstrap()
    }
    
    // MARK: - UI
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupUi() {
        
    }
    
    // MARK: - Content
    
    func setupContent() {
        
    }
    
    // MARK: - Bootstrap
    
    func performBootstrap() {
        self.goToMainMenu()
    }
    
    // MARK: - Navigation
    
    func goToMainMenu() {
        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
        NXUIKitUtil.replaceRootViewController(with: menuViewController)
        
        NotificationCenter.default.post(name: kNotificationBootstrapCompleted, object: nil)
    }
}
