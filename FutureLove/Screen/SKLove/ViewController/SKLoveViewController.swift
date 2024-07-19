//
//  SKLoveViewController.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 25/01/2024.
//

import UIKit
import SETabView
class SKLoveViewController: UIViewController, SETabItemProvider {
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_video(), tag: 0)
    }
    @IBOutlet weak var collectionViewLoveController: UICollectionView!
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
        collectionViewLoveController.backgroundColor = UIColor.clear
        collectionViewLoveController.register(UINib(nibName: "SKLoveCell1", bundle: nil), forCellWithReuseIdentifier: "SKLoveCell1")
        collectionViewLoveController.register(UINib(nibName: "SKLoveCell2", bundle: nil), forCellWithReuseIdentifier: "SKLoveCell2")

    }




}

extension SKLoveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKLoveCell1", for: indexPath) as! SKLoveCell1
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKLoveCell2", for: indexPath) as! SKLoveCell2



        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //        let video = videos[indexPath.item]
//        //        let videoURL = URL(string: video.linkgoc!)
//        //        if let cell = collectionView.cellForItem(at: indexPath) as? CellSwapController {
//        //            cell.setSelectedVideoURL(videoURL)
//        //        }
//
//        indexSellected = indexPath.row
//        collectionViewMain.reloadData()
//
//    }
    //Name section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return  UICollectionReusableView()
    }
}

extension SKLoveViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.row == 0 {
            var width = UIScreen.main.bounds.width
            return CGSize(width: width, height: 101)

        }

        if(UIDevice.current.userInterfaceIdiom == .pad){
            var width = UIScreen.main.bounds.width
            return CGSize(width: width - 5, height: 335)

        }
        var width = UIScreen.main.bounds.width

        return CGSize(width: width - 5, height: 335)

    }
}
