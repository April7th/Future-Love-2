//
//  VideoListVC.swift
//  FutureLove
//
//  Created by khongtinduoc on 11/3/23.
//

import UIKit
import Kingfisher
import AVFoundation
import SETabView

struct VideoThumpImage {
    var linkVideo:String
    var imageThump:UIImage
}

class VideoListVC: UIViewController , SETabItemProvider {
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_love(), tag: 0)
    }
    var listImageThump:[UIImage] = [UIImage] ()
    var listVideoImage :[VideoThumpImage] = [VideoThumpImage]()
    
    var indexSelectPage = 0
    @IBOutlet weak var collectionViewPage: UICollectionView!
    @IBOutlet weak var collectionViewGood: UICollectionView!
    var listVideoPro:[VideoModel] = [VideoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewGood.register(UINib(nibName: videoItemCLVCell.className, bundle: nil), forCellWithReuseIdentifier: videoItemCLVCell.className)
        collectionViewPage.register(UINib(nibName: PageHomeCLVCell.className, bundle: nil), forCellWithReuseIdentifier: PageHomeCLVCell.className)
        loadListVideoAll(pageVideo: 1)
    }
    
    func thumbnailFromVideo(videoUrl: URL, time: CMTime) -> UIImage {
        let asset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do {
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch {
            
        }
        return UIImage()
    }
    
    func loadListVideoAll(pageVideo:Int){
        APIService.shared.ListVideoSwaped(page: pageVideo){response,error in
            self.listVideoPro = response
            self.collectionViewGood.reloadData()
            for item in self.listVideoPro{
                if let url = URL(string: item.link_vid_swap ?? ""){
                    var itemImage : VideoThumpImage = VideoThumpImage(linkVideo: "", imageThump: UIImage())
                    let imageThump:UIImage =  self.thumbnailFromVideo(videoUrl: url, time: CMTime(seconds: Double(1), preferredTimescale: 1))
                    itemImage.linkVideo = item.link_vid_swap ?? ""
                    itemImage.imageThump = imageThump
                    self.listVideoImage.append(itemImage)
                    self.collectionViewGood.reloadData()
                }
            }
            
        }

    }
}
extension VideoListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewPage{
            indexSelectPage = indexPath.row
            self.collectionViewGood.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewPage{
            return 100
        }
        return self.listVideoPro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewPage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageHomeCLVCell.className, for: indexPath) as! PageHomeCLVCell
            cell.pageLabel.text = String(indexPath.row + 1)
            if indexPath.row == indexSelectPage{
                cell.backgroundColor = UIColor.green
            }else{
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoItemCLVCell.className, for: indexPath) as! videoItemCLVCell
        cell.imageVideo.layer.cornerRadius = 50
        cell.imageVideo.layer.masksToBounds = true
        cell.labelName.text = self.listVideoPro[indexPath.row].ten_su_kien ?? ""
        for itemPro in self.listVideoImage{
            if itemPro.imageThump != nil && itemPro.linkVideo == self.listVideoPro[indexPath.row].link_vid_swap {
                cell.imageAnhSwap.image = itemPro.imageThump
                break
            }
        }
        cell.labelTime.text = self.listVideoPro[indexPath.row].thoigian_taovid ?? ""
        let url = URL(string: self.listVideoPro[indexPath.row].link_image ?? "")
        let processor = DownsamplingImageProcessor(size: cell.imageVideo.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 0)
        cell.imageVideo.kf.indicatorType = .activity
        cell.imageVideo.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
}

extension VideoListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewPage{
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: UIScreen.main.bounds.width/20 - 5, height: 40)
            }
            return CGSize(width: UIScreen.main.bounds.width/10 - 5, height: 40)
        }
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width/4 - 10, height: 200)
        }
        return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 200)
    }
}

