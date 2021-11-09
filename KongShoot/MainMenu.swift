//
//  MainMenu.swift
//  KongShoot
//
//  Created by Alex Wayne on 4/9/20.
//  Copyright © 2020 Wayne Apps. All rights reserved.
//

import Foundation
import UIKit

class MainMenu : UIViewController {
    
    var mainmenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print("Touched")
            if mainmenu {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Game")
                vc.modalPresentationStyle = .fullScreen
                if #available( iOS 13.0,*) {
                    vc.isModalInPresentation = true
                }
                self.present(vc, animated: true)
                mainmenu = false
            }
        }
    }
    
    
    
}
