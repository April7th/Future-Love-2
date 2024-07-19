//
//  ListSwapResultVC.swift
//  FutureLove
//
//  Created by khongtinduoc on 11/17/23.
//

import UIKit
import Kingfisher
import AVFoundation

class ListSwapResultVC: UIViewController {
    @IBOutlet weak var buttonBack: UIButton!

    @IBOutlet weak var collectionViewGood: UICollectionView!
    var listTemplateVideo : [ResultVideoModel] = [ResultVideoModel]()
    @IBOutlet weak var collectionViewPage: UICollectionView!
    var indexSelectPage = 0
    @IBAction func BackApp(){
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonBack.setTitle("", for: UIControl.State.normal)

        collectionViewGood.register(UINib(nibName: VideoTemplateCLVCell.className, bundle: nil), forCellWithReuseIdentifier: VideoTemplateCLVCell.className)
        collectionViewPage.register(UINib(nibName: PageHomeCLVCell.className, bundle: nil), forCellWithReuseIdentifier: PageHomeCLVCell.className)
        loadListVideoTemp()
    }
    func loadListVideoTemp(){
        APIService.shared.listAllVideoSwaped(page:1){response,error in
            self.listTemplateVideo = response
            self.collectionViewGood.reloadData()
        }
    }
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return UIImage(named: "noimage")
    }
}

extension ListSwapResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewPage{
            indexSelectPage = indexPath.row
            APIService.shared.listAllVideoSwaped(page:indexSelectPage){response,error in
                self.listTemplateVideo = response
                self.collectionViewGood.reloadData()
            }
            self.collectionViewPage.reloadData()
        }else{
            let vc = DetailSwapVideoVC(nibName: "DetailSwapVideoVC", bundle: nil)
            var itemLink:DetailVideoModel = DetailVideoModel()
            itemLink.linkimg = self.listTemplateVideo[indexPath.row].link_image
            itemLink.link_vid_swap = self.listTemplateVideo[indexPath.row].link_vid_swap
            itemLink.noidung = self.listTemplateVideo[indexPath.row].noidung_sukien
            itemLink.id_sukien_video = self.listTemplateVideo[indexPath.row].id_video
            itemLink.id_video_swap = self.listTemplateVideo[indexPath.row].id_video
            itemLink.ten_video = self.listTemplateVideo[indexPath.row].ten_su_kien
            itemLink.idUser = self.listTemplateVideo[indexPath.row].id_user
//            itemLink.thoigian_swap = Floatself.listTemplateVideo[indexPath.row].thoigian_taovid
//\            itemLink.device_tao_vid = self.listTemplateVideo[indexPath.row].thoigian_taovid
            itemLink.thoigian_sukien = self.listTemplateVideo[indexPath.row].thoigian_taosk
            itemLink.link_video_goc = self.listTemplateVideo[indexPath.row].link_vid_swap
            itemLink.ip_tao_vid = self.listTemplateVideo[indexPath.row].id_video
            itemLink.link_vid_swap = self.listTemplateVideo[indexPath.row].link_vid_swap
            vc.itemDataSend = itemLink
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewPage{
            return 100
        }
        return self.listTemplateVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewPage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageHomeCLVCell.className, for: indexPath) as! PageHomeCLVCell
            cell.pageLabel.text = String(indexPath.row + 1)
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            if indexPath.row == indexSelectPage{
                cell.backgroundColor = UIColor.green
            }else{
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoTemplateCLVCell.className, for: indexPath) as! VideoTemplateCLVCell
        cell.imageVideo.layer.cornerRadius = 10
        cell.imageVideo.layer.masksToBounds = true
        cell.labelTimeRun.text = "Time Swap: " + (self.listTemplateVideo[indexPath.row].thoigian_swap ?? "")
        cell.labelName.text = self.listTemplateVideo[indexPath.row].thoigian_taosk ?? ""
//        if let url = URL(string: self.listTemplateVideo[indexPath.row].link_vid_swap ?? ""){
//            cell.imageVideo.image = getThumbnailImage(forUrl: url)
//        }
        let url = URL(string: self.listTemplateVideo[indexPath.row].link_image ?? "")
        let processor = DownsamplingImageProcessor(size: cell.imageVideo.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 10)
        cell.imageVideo.kf.indicatorType = .activity
        cell.imageVideo.kf.setImage(
            with: url,
            placeholder: UIImage(named: "hoapro"),
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

extension ListSwapResultVC: UICollectionViewDelegateFlowLayout {
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
                return CGSize(width: UIScreen.main.bounds.width/20 - 10, height: 50)
            }
            return CGSize(width: UIScreen.main.bounds.width/10 - 10, height: 50)
        }
        
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width/4 - 10, height: 230)
        }
        return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 230)
    }
}

