//
//  myExtention.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import Foundation
import UIKit
extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: IndexPath.init(row: row - 1, section: section - 1), at: .bottom, animated: false)
            }
        }
    }
}
extension UIWindow {
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
            
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if vc.isKind (of:UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
                
            } else {
                
                return vc;
            }
        }
}
}
