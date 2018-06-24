//
//  ChatTableViewCell.swift
//  Macetohuerto
//
//  Created by Lopez Centelles, Josep on 23/06/2018.
//  Copyright © 2018 Josep. All rights reserved.
//

import Foundation
import UIKit

class ChatTableViewCell: UITableViewCell {
    
    public static let reuseIdentifier = "chatrow"

    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var plantImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = UIColor.gray
        return label
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageLabel)
        contentView.addSubview(plantImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16.0),
            messageLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16.0),
            messageLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0),
            messageLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -16.0)
            ])
        
        NSLayoutConstraint.activate([
            plantImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16.0),
            plantImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16.0),
            plantImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0),
            plantImageView.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -16.0),
            ])

        NSLayoutConstraint.activate([
            authorLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16.0),
            authorLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16.0),
            authorLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16.0),
            dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16.0),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(_ message: Message) {
        messageLabel.text = message.text
        authorLabel.text = message.name
        dateLabel.text = message.date
        plantImageView.image = nil

        if !message.photoUrl.isEmpty {
            plantImageView.downloadedFrom(link: message.photoUrl)
        } else {
            plantImageView.image = nil
        }
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        if let data = try? Data(contentsOf: url) {
            self.image = UIImage(data: data)
        }
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}



