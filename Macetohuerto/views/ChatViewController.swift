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
import FirebaseAuth
import FirebaseUI

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
    
    lazy var sendButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        let image = UIImage(named: "send") as UIImage?
        button.setImage(image, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var inputField: UITextField = {
        var input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.backgroundColor = .white
        input.layer.borderWidth = 1
        /*input.layer.cornerRadius = 10.0
        input.layer.borderColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha: 1).cgColor*/
        input.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        return input
    }()
    
    @objc func btnTouched(_ textField: UIButton) {
        if self.loggedUser == nil {
            showLoginDialog()
        } else {
            let objectToSave = toAnyObject()
            print(objectToSave)
                
            ref.child("messages").childByAutoId().setValue(objectToSave) {
                (error, ref) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                    self.inputField.text = ""
                }
            }
        }
    }
    
    func toAnyObject() -> [String : String]  {
        if let textMessage = inputField.text,
            let authorMessage = loggedUser?.displayName {
            let newMessageData = [
                "date": Date().dateFormattedForChat,
                "name": authorMessage,
                "text": textMessage
            ]
            return newMessageData
        }
        return [:]
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.sendButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    private final let perPage: UInt = 50
    var loggedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                self.view.frame.origin.y += 49 //bar
            }
        }
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        inputField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ref = Database.database().reference()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        
        self.view.addSubview(myTableView)
        self.view.addSubview(inputField)
        self.view.addSubview(sendButton)
        
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.rowHeight = UITableViewAutomaticDimension

        myTableView.backgroundColor = .gray
        
        NSLayoutConstraint.activate([
            inputField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8),
            inputField.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor),
            inputField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            inputField.topAnchor.constraint(equalTo: self.sendButton.topAnchor)
            ])
        
        NSLayoutConstraint.activate([
            sendButton.leftAnchor.constraint(equalTo: self.inputField.rightAnchor),
            sendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50.0)
            ])
        
        NSLayoutConstraint.activate([
            myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            myTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            myTableView.bottomAnchor.constraint(equalTo: self.inputField.topAnchor)
            ])
        
        ref.child("messages").queryOrderedByKey()
            .queryLimited(toLast: perPage)
            .observe(.value, with: { (snapshot) in
                print("event here")
                for postSnapshot in snapshot.children {
                    guard let snap = (postSnapshot as? DataSnapshot)
                        else { continue }
                    if let message = snap.value as? [String:AnyObject] {
                        let name = message["name"] as? String ?? ""
                        let text = message["text"] as? String ?? ""
                        let date = message["date"] as? String ?? ""
                        let photoUrl = message["photoUrl"] as? String ?? ""
                        self.messageList.append(Message(name: name, text: text, date: date, photoUrl: photoUrl))
                    }
                }
                self.myTableView.reloadData()
                if self.messageList.count > 0 {
                    self.myTableView.scrollToRow(at: IndexPath(item: self.messageList.count-1, section: 0), at: .bottom, animated: true)
                }
                
            }) { (error) in
                print(error.localizedDescription)
        }
        
        
    }
}

extension ChatViewController: FUIAuthDelegate {
    
    func showLoginDialog() {
        let alert = UIAlertController(title: "autenticate".localized, message: "autenticate_description".localized, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if action.style == .default {
                self.showLoginPage()
            }
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoginPage() {
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI?.providers = providers
        if let authViewController = authUI?.authViewController() {
            present(authViewController, animated: true, completion: nil)
        }
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.loggedUser = user
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as! ChatTableViewCell
        cell.bind(self.messageList[indexPath.row])
        if self.messageList[indexPath.row].photoUrl.count > 0 {
            cell.imageView?.image = UIImage(named: "maceta")
            cell.imageView?.downloadImageFrom(link: messageList[indexPath.row].photoUrl, contentMode: UIViewContentMode.scaleAspectFit)
        } else {
            cell.imageView?.image = nil
        }
       

        return cell
    }
}

extension Date {
    var dateFormattedForChat: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatterPrint.string(from: self)
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension ChatViewController {
    func downloadImage(link: String, imageView: UIImageView) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    imageView.image = UIImage(data: data)
                }
            }
        }).resume()
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                    
                }
            }
        }).resume()
    }
}
