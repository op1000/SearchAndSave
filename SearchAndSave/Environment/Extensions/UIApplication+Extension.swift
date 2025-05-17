//
//  UIApplication+Extension.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import UIKit

public extension UIApplication {
    class func topViewController(
        _ base: UIViewController? = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first { $0.isKeyWindow }?
            .rootViewController
    ) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
