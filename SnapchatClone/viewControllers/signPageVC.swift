//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Mustafa Göktuğ İbolar on 10.08.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class signPageVC: UIViewController {
    
    let titleLabel = UILabel()
    let mailTextfield = UITextField()
    let usernameTextfield = UITextField()
    let passwordTextfield = UITextField()
    let signinButton = UIButton()
    let signupButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.size.width
        let height = view.frame.size.height
        view.backgroundColor = .yellow
        
        
        //LABEL
        titleLabel.text = "SnapChat"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 25)
        titleLabel.frame = CGRect(x: width * 0.35, y: height * 0.06, width: width * 0.3, height: height * 0.04)
        view.addSubview(titleLabel)
     
        //TEXTFIELDS
        mailTextfield.placeholder = "email"
        mailTextfield.autocapitalizationType = .none
        mailTextfield.borderStyle = .roundedRect
        mailTextfield.backgroundColor = .yellow
        mailTextfield.frame = CGRect(x: width * 0.1, y: height * 0.15, width: width * 0.8, height: height * 0.04)
        view.addSubview(mailTextfield)
        
        usernameTextfield.placeholder = "username"
        usernameTextfield.autocapitalizationType = .none
        usernameTextfield.borderStyle = .roundedRect
        usernameTextfield.backgroundColor = .yellow
        usernameTextfield.frame = CGRect(x: width * 0.1, y: height * 0.2, width: width * 0.8, height: height * 0.04)
        view.addSubview(usernameTextfield)
        
        passwordTextfield.placeholder = "password"
        passwordTextfield.autocapitalizationType = .none
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.borderStyle = .roundedRect
        passwordTextfield.backgroundColor = .yellow
        passwordTextfield.frame = CGRect(x: width * 0.1, y: height * 0.25, width: width * 0.8, height: height * 0.04)
        view.addSubview(passwordTextfield)
        
        //BUTTONS
        signinButton.setTitle("sign in", for: UIControl.State.normal)
        signinButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        signinButton.frame = CGRect(x: width * 0.1, y: height * 0.32, width: width * 0.15, height: height * 0.04)
        signinButton.addTarget(self, action: #selector(signinButtonClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(signinButton)
        
        signupButton.setTitle("sign up", for: UIControl.State.normal)
        signupButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        signupButton.frame = CGRect(x: width * 0.75, y: height * 0.32, width: width * 0.15, height: height * 0.04)
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(signupButton)
    }
    @objc func signinButtonClicked(){
        if mailTextfield.text != nil && passwordTextfield.text != nil{
            Auth.auth().signIn(withEmail: mailTextfield.text!, password: passwordTextfield.text!) { authResult, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                   
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
              
            }
        }
        else{
            self.makeAlert(titleInput: "Error", messageInput: "Email/password")
        }
        
        
    }
    @objc func signupButtonClicked(){
        if usernameTextfield.text != "" &&  mailTextfield.text != "" && passwordTextfield.text != "" {
            Auth.auth().createUser(withEmail: mailTextfield.text!, password: passwordTextfield.text!) { authResult, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email" : self.mailTextfield.text!,"username": self.usernameTextfield.text!] as [String : Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil {
                            //
                        }
                    }
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        
        }
        else{
            makeAlert(titleInput: "Error!", messageInput: "Email/password")
        }

    }
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

}
