//
//  feedVC.swift
//  SnapchatClone
//
//  Created by Mustafa Göktuğ İbolar on 10.08.2022.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorage
import FirebaseDatabase
import FirebaseCore


class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(feedCell.self, forCellReuseIdentifier: feedCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let height = view.frame.size.height
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .yellow
        self.tableView.rowHeight = height * 0.7
        view.addSubview(tableView)
        
        getSnapsFromFirebase()
        get_userInfo()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    func getSnapsFromFirebase() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                            
                                            }
                                                
                                        } else {
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference )
                                            self.snapArray.append(snap)
                                            print("snapArray updated")
                                            
                                        }
                                       
                                        
                                    }
                                    
                                   
                                    
                                }
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
    
    func get_userInfo(){
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
                  if error != nil {
                      self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                  } else {
                      if snapshot?.isEmpty == false && snapshot != nil {
                          for document in snapshot!.documents {
                              if let username = document.get("username") as? String {
                                  UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                                  UserSingleton.sharedUserInfo.username = username
                              }
                          }
                      }
                  }
              }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCell.identifier, for: indexPath) as! feedCell
        cell.backgroundColor = .yellow
        cell.feedUserNameLabel.text = snapArray[indexPath.row].username
        cell._imageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    func makeAlert(title: String, message: String) {
              let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
              let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
              alert.addAction(okButton)
              self.present(alert, animated: true, completion: nil)
          }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! snapVC
            destinationVC.selectedSnap = chosenSnap
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }

}
