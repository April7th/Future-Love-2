//
//  SwapImage_VideoTemplateVC.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 22/01/2024.
//

import UIKit
import SETabView

class SwapImage_VideoTemplateVC: UIViewController, SETabItemProvider {
     
        var seTabBarItem: UITabBarItem? {
            return UITabBarItem(title: "", image: R.image.tab_video(), tag: 0)
        }
    @IBOutlet weak var collectionViewMain: UICollectionView!
    var videos : [TempleVideoModel] = []
    var video: TempleVideoModel = TempleVideoModel()
    let api = APIService()
    var indexSellected = -1
    var check : Bool = true
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

        api.listTemplateVideoSwap { [weak self] videos, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching videos: \(error)")
            } else {
                self.videos = videos
                DispatchQueue.main.async {
                    self.collectionViewMain.reloadData()
                }
            }
        }

        collectionViewMain.register(UINib(nibName: "SwapImage_VideoTemplateCell", bundle: nil), forCellWithReuseIdentifier: "SwapImage_VideoTemplateCell")
        collectionViewMain.register(UINib(nibName: "CellSwapController", bundle: nil), forCellWithReuseIdentifier: "CellSwapController")
        collectionViewMain.register(UINib(nibName: "CellFirst", bundle: nil), forCellWithReuseIdentifier: "CellFirst")
        collectionViewMain.register(UINib(nibName: "CellSwap1", bundle: nil), forCellWithReuseIdentifier: "CellSwap1")
        collectionViewMain.register(UINib(nibName: "CellSwap2", bundle: nil), forCellWithReuseIdentifier: "CellSwap2")
        collectionViewMain.register(UINib(nibName: "CellSwap3", bundle: nil), forCellWithReuseIdentifier: "CellSwap3")
    }


}

extension SwapImage_VideoTemplateVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(!check){
            return videos.count + 2
        }
        return videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFirst", for: indexPath) as! CellFirst
            return cell
        }
//        if(indexPath.row == 1){
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSwap1", for: indexPath) as! CellSwap1
//            cell.isHidden = check
//            return cell
//        }
//        if(indexPath.row == 2){
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSwap2", for: indexPath) as! CellSwap2
//            cell.isHidden = check
//            return cell
//        }
//        if(indexPath.row == 3){
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSwap3", for: indexPath) as! CellSwap3
//            cell.isHidden = check
//            return cell
//        }

        if(indexPath.row == 1){

            if(!check){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSwapController", for: indexPath) as! CellSwapController
                let video = video
                if let urlString = video.linkThump, let url = URL(string: urlString) {
                    cell.updateImageThumb2(URL(string: video.linkThump!))
                }
                cell.setSelectedVideoURL(URL(string: video.linkgoc!), video.id)
                print("real linkvd \(video.linkgoc!) real id \(video.id)")
                cell.isHidden = check
                return cell
            }

            //            if let urlString = video.linkThump, let url = URL(string: urlString) {
            //                URLSession.shared.dataTask(with: url) { (data, response, error) in
            //                    if let data = data, let image = UIImage(data: data) {
            //                        DispatchQueue.main.async {
            //                            cell.updateImageThumb2(with: image)
            //                        }
            //                    }
            //                }.resume()
            //            }

        }
        //Load ImageThumb
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwapImage_VideoTemplateCell", for: indexPath) as! SwapImage_VideoTemplateCell
        let video = videos[indexPath.item]
        if let urlString = video.linkThump, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageThump.image = image
                    }
                }
            }.resume()
        }


        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let video = videos[indexPath.item]
        //        let videoURL = URL(string: video.linkgoc!)
        //        if let cell = collectionView.cellForItem(at: indexPath) as? CellSwapController {
        //            cell.setSelectedVideoURL(videoURL)
        //        }

        indexSellected = indexPath.row
        video = videos[indexPath.item]
        check = false
        collectionViewMain.reloadData()

    }
    //Name section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return  UICollectionReusableView()
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension SwapImage_VideoTemplateVC: UICollectionViewDelegateFlowLayout{

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
        if indexPath.row == 1 && !check {
            var width = UIScreen.main.bounds.width
            return CGSize(width: width - 5, height: width * 3)

        }
        if(UIDevice.current.userInterfaceIdiom == .pad){
            var width = UIScreen.main.bounds.width/6
            return CGSize(width: width - 5, height: width/4*3)

        }
        var width = UIScreen.main.bounds.width/2

        return CGSize(width: width - 5, height: width/4*3)

    }


}

