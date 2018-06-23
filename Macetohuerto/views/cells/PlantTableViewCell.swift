//
//  PlantTableViewCell.swift
//  Macetohuerto
//
//  Created by Lopez Centelles, Josep on 22/06/2018.
//  Copyright © 2018 Josep. All rights reserved.
//

import Foundation
import UIKit

class PlantTableViewCell: UICollectionViewCell {
    public static let reuseIdentifier = "plantrow"
    
    var messageLabel = UILabel()
    var imagePlant = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        messageLabel.textColor = .black
        imagePlant = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
        imagePlant.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(imagePlant)
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: imagePlant.frame.size.height, width: frame.size.width, height: frame.size.height/3))
        messageLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        messageLabel.textAlignment = .center
        contentView.addSubview(messageLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
