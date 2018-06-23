//
//  ChatViewController.swift
//  Macetohuerto
//
//  Created by Lopez Centelles, Josep on 23/06/2018.
//  Copyright © 2018 Josep. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

public struct Message {
    let name: String
    let text: String
    let date: String
    let photoUrl: String
}

class ChatViewController: ViewController {
    var ref: DatabaseReference!
    var messageList = [Message]()
    var myTableView: UITableView = UITableView()

    private final let perPage: UInt = 50

    
    override func viewDidAppear(_ animated: Bool) {

        ref = Database.database().reference()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        
        self.view.addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.backgroundColor = .red
        NSLayoutConstraint.activate([
            myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            myTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70.0),
            myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        
        ref.child("messages").queryOrderedByKey()
            .queryLimited(toLast: perPage)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                for postSnapshot in snapshot.children {
                    guard let snap = (postSnapshot as? DataSnapshot)
                         else { continue }
                    let message = snap.value as AnyObject
                    let name = message["name"] as? String ?? ""
                    let text = message["text"] as? String ?? ""
                    let date = message["date"] as? String ?? ""
                    let photoUrl = message["photoUrl"] as? String ?? ""
                    self.messageList.append(Message(name: name, text: text, date: date, photoUrl: photoUrl))
                }
        
                self.myTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as! ChatTableViewCell
        cell.bind(self.messageList[indexPath.row])
        return cell
    }
}

