//
//  CellSwapController.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 22/01/2024.
//

import UIKit

class CellSwapController: UICollectionViewCell {

    
    @IBOutlet weak var cellSwapCollectionView: UICollectionView!
    var cellConNames = ["CellSwap1", "CellSwap2", "CellSwap3"]
    let spinner = UIActivityIndicatorView(style: .large)
    var selectedVideoURL: URL?
    var idVideoGoc: Int?
    var thumbURL: URL?
    var imageThumb2: UIImage?
    var linkVideoDowload: URL?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellSwapCollectionView.backgroundColor = .clear
        for cellConName in cellConNames {
            cellSwapCollectionView.register(UINib(nibName: cellConName, bundle: nil), forCellWithReuseIdentifier: cellConName)
        }
    }
    func setSelectedVideoURL(_ url: URL?, _ id: Int?) {
        selectedVideoURL = url
        idVideoGoc = id
        cellSwapCollectionView.reloadData()
    }
    func updateImageThumb2(_ url: URL?) {

        thumbURL = url

        cellSwapCollectionView.reloadData()
    }


}



extension CellSwapController: UICollectionViewDelegate, UICollectionViewDataSource, CellSwap2Delegate {
    func didSelectVideoURL(_ videoURL: URL?) {
        if let videoURL = videoURL {
            print("Selected video URL: \(videoURL)")
            self.linkVideoDowload = videoURL
            cellSwapCollectionView.reloadData()
        }
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellConName = cellConNames[indexPath.row % cellConNames.count]
        if cellConName == "CellSwap1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSwap1", for: indexPath) as! CellSwap1
            cell.configureCell(with: selectedVideoURL)
            return cell
        }
        if cellConName == "CellSwap2" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSwap2", for: indexPath) as! CellSwap2
            cell.delegate = self
            cell.videoURL(selectedVideoURL, idVideoGoc)
            URLSession.shared.dataTask(with: thumbURL!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageThumb.image = image
                        //self.cellSwapCollectionView.reloadData()
                    }
                }
            }.resume()

            return cell
        }
        if cellConName == "CellSwap3" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSwap3", for: indexPath) as! CellSwap3
            // Hiển thị indicator loading
            cell.configureCellVideo(with: linkVideoDowload)



            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellConName, for: indexPath)
        return cell
    }
    //Name section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return  UICollectionReusableView()
    }
}

extension CellSwapController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(UIDevice.current.userInterfaceIdiom == .pad){
            return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 365)

        }
        return CGSize(width: UIScreen.main.bounds.width, height: 365)
    }
}
