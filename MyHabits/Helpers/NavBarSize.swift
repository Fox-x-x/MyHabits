//
//  NavBarSize.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 08.11.2020.
//

import UIKit

extension UIViewController {
    
    /// высота status bar + navigation bar
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
