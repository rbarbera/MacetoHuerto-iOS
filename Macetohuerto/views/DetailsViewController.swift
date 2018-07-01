//
//  DetailsViewController.swift
//  Macetohuerto
//
//  Created by Lopez Centelles, Josep on 29/06/2018.
//  Copyright © 2018 Josep. All rights reserved.
//

import Foundation
import UIKit

public class DetailsViewController: UIViewController {
    
    public var vegetable: Vegetable!
    public var allVegetables: Vegetables!
    
    lazy var companionsListView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 35, height: 50)
        layout.scrollDirection = .horizontal

        let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.tag = 0
        myCollectionView.register(PlantTableViewCell.self, forCellWithReuseIdentifier: PlantTableViewCell.reuseIdentifier)
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return myCollectionView
    }()
    
    lazy var antagonistListView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 35, height: 50)
        layout.scrollDirection = .horizontal
        
        let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.tag = 1
        myCollectionView.register(PlantTableViewCell.self, forCellWithReuseIdentifier: PlantTableViewCell.reuseIdentifier)
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return myCollectionView
    }()

    fileprivate lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "huerto")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var circularBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 40.0

        return view
    }()
    
    fileprivate lazy var waterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor =  UIColor(red: 30.0/255.0, green: 108.0/255.0, blue: 167.0/255.0, alpha: 1.00)
        view.layer.cornerRadius = 10.0
        
        return view
    }()
    
    fileprivate lazy var litersImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "maceta")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = label.font.withSize(14)
        label.textColor = .gray
        return label
    }()
    
    fileprivate lazy var litersDescLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "litros_nsustrato".localized
        label.font = label.font.withSize(14)
        return label
    }()
    
    fileprivate lazy var waterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "cantidad_de_riego".localized
        label.font = label.font.withSize(14)
        return label
    }()
    
    fileprivate lazy var companionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "companion_vegetables".localized
        label.font = label.font.withSize(14)
        return label
    }()
    
    fileprivate lazy var antagonistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "antagonist_vegetables".localized
        label.font = label.font.withSize(14)
        return label
    }()

    
    fileprivate lazy var litersQuantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = label.font.withSize(16)
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var plantImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = vegetable.placeholder.localized
        self.plantImageView.image = UIImage(named: vegetable.image)
        self.descriptionLabel.text = vegetable.desc.localized
        self.litersQuantityLabel.text = String(vegetable.capacity)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width - 32
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        scrollView.addSubview(bannerImageView)
        scrollView.addSubview(circularBorder)
        scrollView.addSubview(plantImageView)
        scrollView.addSubview(litersDescLabel)
        scrollView.addSubview(litersImageView)
        scrollView.addSubview(litersQuantityLabel)
        scrollView.addSubview(waterLabel)
        scrollView.addSubview(waterView)
        scrollView.addSubview(companionLabel)
        scrollView.addSubview(companionsListView)
        scrollView.addSubview(antagonistLabel)
        scrollView.addSubview(antagonistListView)
        scrollView.addSubview(descriptionLabel)
        
        
        NSLayoutConstraint.activate([
            bannerImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bannerImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bannerImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: -20.0)
            ])
        
        NSLayoutConstraint.activate([
            waterLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            waterLabel.topAnchor.constraint(equalTo: self.litersDescLabel.bottomAnchor, constant: 16.0),
            waterLabel.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant: -16.0)
            ])
        
        NSLayoutConstraint.activate([
            waterView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            waterView.heightAnchor.constraint(equalToConstant: 20.0),
            waterView.widthAnchor.constraint(equalToConstant: screenWidth * CGFloat(vegetable.water)),
            waterView.topAnchor.constraint(equalTo: self.waterLabel.bottomAnchor, constant: 8.0)
            ])
        
        NSLayoutConstraint.activate([
            companionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            companionLabel.topAnchor.constraint(equalTo: self.waterView.bottomAnchor, constant: 16.0),
            companionLabel.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant: -16.0)
            ])
        
        
        NSLayoutConstraint.activate([
            companionsListView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            companionsListView.topAnchor.constraint(equalTo: self.companionLabel.bottomAnchor, constant: 16.0),
            companionsListView.heightAnchor.constraint(equalToConstant: 50.0),
            companionsListView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0)
            ])
        
        NSLayoutConstraint.activate([
            antagonistLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            antagonistLabel.topAnchor.constraint(equalTo: self.companionsListView.bottomAnchor, constant: 8.0),
            antagonistLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0)
            ])
        
        NSLayoutConstraint.activate([
            antagonistListView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            antagonistListView.topAnchor.constraint(equalTo: self.antagonistLabel.bottomAnchor, constant: 16.0),
            antagonistListView.heightAnchor.constraint(equalToConstant: 50.0),
            antagonistListView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0)
            ])
        
        NSLayoutConstraint.activate([
            plantImageView.centerXAnchor.constraint(equalTo: bannerImageView.centerXAnchor),
            plantImageView.centerYAnchor.constraint(equalTo: bannerImageView.centerYAnchor),
            plantImageView.heightAnchor.constraint(equalToConstant: 55.0),
            plantImageView.widthAnchor.constraint(equalToConstant: 55.0),
            ])
        
        NSLayoutConstraint.activate([
            circularBorder.centerXAnchor.constraint(equalTo: bannerImageView.centerXAnchor),
            circularBorder.centerYAnchor.constraint(equalTo: bannerImageView.centerYAnchor),
            circularBorder.heightAnchor.constraint(equalToConstant: 80.0),
            circularBorder.widthAnchor.constraint(equalToConstant: 80.0),
            ])
        
        NSLayoutConstraint.activate([
            litersDescLabel.centerYAnchor.constraint(equalTo: self.litersImageView.centerYAnchor),
            litersDescLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0)
            ])
        
        NSLayoutConstraint.activate([
            litersImageView.topAnchor.constraint(equalTo: self.bannerImageView.bottomAnchor),
            litersImageView.leftAnchor.constraint(equalTo: litersDescLabel.rightAnchor, constant: 5.0)
            ])
        NSLayoutConstraint.activate([
            litersQuantityLabel.bottomAnchor.constraint(equalTo: self.litersImageView.bottomAnchor, constant: -3),
            litersQuantityLabel.centerXAnchor.constraint(equalTo: self.litersImageView.centerXAnchor)           ])
        
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            descriptionLabel.topAnchor.constraint(equalTo: antagonistListView.bottomAnchor, constant: 8.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0)
            ])
    
        
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return allVegetables.companionVegetables(vegetable: self.vegetable).count
        } else {
            return allVegetables.antagonistVegetables(vegetable: self.vegetable).count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantTableViewCell.reuseIdentifier, for: indexPath as IndexPath) as! PlantTableViewCell
        let vegetable = collectionView.tag == 0 ?
            allVegetables.companionVegetables(vegetable: self.vegetable)[indexPath.item] :
            allVegetables.antagonistVegetables(vegetable: self.vegetable)[indexPath.item]
        myCell.messageLabel.numberOfLines = 2
        myCell.imagePlant.image = UIImage(named: vegetable.image)
        
        return myCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        let view = DetailsViewController()
         let vegetableClicked = collectionView.tag == 0 ?
            allVegetables.companionVegetables(vegetable: self.vegetable)[indexPath.item] :
            allVegetables.antagonistVegetables(vegetable: self.vegetable)[indexPath.item]
        view.vegetable = vegetableClicked
        view.allVegetables = allVegetables
        self.navigationController?.pushViewController(view, animated: true)
        
    }
}
