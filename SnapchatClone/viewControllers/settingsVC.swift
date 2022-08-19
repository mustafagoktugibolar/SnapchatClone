//
//  settingsVC.swift
//  SnapchatClone
//
//  Created by Mustafa Göktuğ İbolar on 10.08.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class settingsVC: UIViewController {
    let logoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.size.width
        let height = view.frame.size.height
        view.backgroundColor = .yellow
        
        //BUTTONS
        logoutButton.setTitle("log out", for: UIControl.State.normal)
        logoutButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonClicked), for: UIControl.Event.touchUpInside)
        logoutButton.frame = CGRect(x: width * 0.4, y: height * 0.4, width: width * 0.2 , height: height * 0.05)
        view.addSubview(logoutButton)

        
    }
    @objc func logoutButtonClicked(){
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignPageVC", sender: nil)
        } catch {
            
        }
        
    }
    
}
