//
//  Swap2ImageVC.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 17/01/2024.
//

import UIKit
import SETabView

class Swap2ImageVC: UIViewController, SETabItemProvider {

    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_video(), tag: 0)
    }
    @IBOutlet weak var collectionViewMain: UICollectionView!
    let cellNames = ["Cell0", "Cell1", "Cell2", "Cell3", "Cell4", "Cell5", "Cell6", "Cell7", "Cell8", "Cell9"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.main.bounds
        gradientLayer.colors = [
            UIColor(red: 229/255.0, green: 166/255.0, blue: 190/255.0, alpha: 1.0).cgColor,
            UIColor(red: 171/255.0, green: 122/255.0, blue: 203/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
        collectionViewMain.backgroundColor = UIColor.clear

        for cellName in cellNames {
            collectionViewMain.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        }



    }
}

extension Swap2ImageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellName = cellNames[indexPath.row % cellNames.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }

    //Name section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return  UICollectionReusableView()
    }
}

extension Swap2ImageVC: UICollectionViewDelegateFlowLayout{

    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        let paddingWidth = (collectionView.frame.size.width - 406) / 2
    //        let paddingHeight = (collectionView.frame.size.height - 525) / 2
    //        return UIEdgeInsets(top: paddingHeight, left: paddingWidth, bottom: paddingHeight, right: paddingWidth)
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 0){
            return CGSize(width: UIScreen.main.bounds.width - 10, height: 100)
        }
        if(UIDevice.current.userInterfaceIdiom == .pad){
            return CGSize(width: UIScreen.main.bounds.width - 10, height: 365)

        }
        return CGSize(width: UIScreen.main.bounds.width - 10, height: 720)
    }
}
