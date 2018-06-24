//
//  ViewController.swift
//  Macetohuerto
//
//  Created by Lopez Centelles, Josep on 16/06/2018.
//  Copyright © 2018 Josep. All rights reserved.
//

import UIKit

struct Vegetables: Decodable {
    var vegetables: [Vegetable]
}

struct Vegetable: Decodable {
    let placeholder: String
    let image: String
    let seeds, plants, harvests: [Int]
    
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let actions = ["semilleros".localized, "plantar".localized, "cosechar".localized]
    
    let months = ["enero".localized, "febrero".localized, "marzo".localized, "abril".localized, "mayo".localized, "junio".localized,
                  "julio".localized, "agosto".localized, "septiembre".localized, "octubre".localized, "noviembre".localized, "diciembre".localized]
    
    var monthSelected = 0
    var actionSelected = 0
    
    var allVegetables: Vegetables!
    var visibleVegetables: Vegetables!
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 75, height: 150)
        
        let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(PlantTableViewCell.self, forCellWithReuseIdentifier: PlantTableViewCell.reuseIdentifier)
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return myCollectionView
    }()
    
    lazy var actionPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        pickerView.backgroundColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let date = Date()
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: date) - 1
        print(month)
        pickerView.selectRow(1, inComponent: 0, animated: true)
        pickerView.selectRow(month, inComponent: 1, animated: true)
        monthSelected = month
        actionSelected = 1
        calculateVisibleVegetables()
        pickerView.reloadAllComponents()
        return pickerView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        if let path = Bundle.main.path(forResource: "plants", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let myStruct = try JSONDecoder().decode(Vegetables.self, from: data) // Decoding our data
                allVegetables = myStruct
                visibleVegetables = allVegetables
                
            } catch (let error) {
                // handle error
                print(error)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(actionPicker)
        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            actionPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            actionPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            actionPicker.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70.0),
            actionPicker.heightAnchor.constraint(equalToConstant: 80.0)
            ])
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0),
            collectionView.topAnchor.constraint(equalTo: self.actionPicker.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleVegetables.vegetables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantTableViewCell.reuseIdentifier, for: indexPath as IndexPath) as! PlantTableViewCell
        let vegetable = visibleVegetables?.vegetables[indexPath.item]
        myCell.messageLabel.text = vegetable?.placeholder.localized
        myCell.messageLabel.numberOfLines = 2
        myCell.imagePlant.image = UIImage(named: (vegetable?.image)!)

        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return actions.count
        } else {
            return months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return actions[row]
        } else {
            return months[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            actionSelected = row
        } else if (component == 1) {
            monthSelected = row
        }
        calculateVisibleVegetables()
    }
}

extension ViewController {
    func calculateVisibleVegetables() {
        var calculatedVegetables = [Vegetable]()
        for vegetable in allVegetables.vegetables {
            if isVegetableVisible(action: actionSelected, month: monthSelected, vegetable: vegetable) {
                calculatedVegetables.append(vegetable)
            }
        }
        visibleVegetables.vegetables = calculatedVegetables
        collectionView.reloadData()
    }
    
    func isVegetableVisible(action: Int, month: Int, vegetable: Vegetable) -> Bool {
        if (action == 0) {
            return vegetable.seeds.contains(month)
        } else if (action == 1) {
            return vegetable.plants.contains(month)
        } else if (action == 2) {
            return vegetable.harvests.contains(month)
        }
        
        return false
    }
}



