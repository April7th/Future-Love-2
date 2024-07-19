//
//  TabbarViewController.swift
//  FutureLove
//
//  Created by TTH on 25/07/2023.
//

import UIKit
import SETabView

class TabbarViewController: SETabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tab bar look
        setTabColors(backgroundColor: R.color.tabbar() ?? .red,
                     ballColor: .clear,
                     tintColor: .black,
                     unselectedItemTintColor: .white,
                     barTintColor: .clear)
        
        // set view controllers
        setViewControllers(getViewControllers())
    }
    
    private func getViewControllers() -> [UIViewController] {
        return [
            SwapImageImageVC(nibName: "SwapImageImageVC", bundle: nil),
            HomeViewController(nibName: "HomeViewController", bundle: nil),
            //CommentsViewController(nibName: "CommentsViewController", bundle: nil),
            SKLoveVC(nibName: "SKLoveVC", bundle: nil),
            SwapImageVideoUploadVC(nibName: "SwapImageVideoUploadVC", bundle: nil),
            //Swap2ImageVC(nibName: "Swap2ImageVC", bundle: nil),
            SwapImage_VideoTemplateVC(nibName: "SwapImage_VideoTemplateVC", bundle: nil)
        ]
    }


}
