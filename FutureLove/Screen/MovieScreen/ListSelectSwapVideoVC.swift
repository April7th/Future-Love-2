//
//  ListSelectSwapVideoVC.swift
//  FutureLove
//
//  Created by khongtinduoc on 11/3/23.
//

import UIKit
import Kingfisher
import SETabView
import AVFoundation
import StoreKit

class ListSelectSwapVideoVC: UIViewController , SETabItemProvider {
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_video(), tag: 0)
    }
    @IBOutlet weak var collectionViewGood: UICollectionView!
    var listTemplateVideo : [Temple2VideoModel] = [Temple2VideoModel]()
    @IBOutlet weak var collectionViewPage: UICollectionView!
    var indexSelectPage = 0
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6463770787") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let url = URL(string: AppConstant.linkAvatar.asStringOrEmpty()){
            avatarImage.af.setImage(withURL: url)
        }
        let nameDevice = UIDevice.current.name
        if let userIDPro = AppConstant.userId , let tokenID = AppConstant.tokenID{
            APIService.shared.postTokenNotification(token: tokenID, userID: String(userIDPro), deviceName: nameDevice){repond , error in
                print(repond)
            }
        }
    }
    
    @IBAction func actionNextProfile(_ sender: Any) {
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        vc.userId = AppConstant.userId ?? 0
        vc.callAPIRecentComment()
        vc.callApiProfile()
        vc.callAPIUserEvent()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func MenuActionPro(){
        let vc = ListSwapResultVC(nibName: "ListSwapResultVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            dismiss(animated: true, completion: nil)
        }
        let vc = ListSwapResultVC(nibName: "ListSwapResultVC", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        rateApp()
        collectionViewGood.register(UINib(nibName: VideoTemplateCLVCell.className, bundle: nil), forCellWithReuseIdentifier: VideoTemplateCLVCell.className)
        collectionViewPage.register(UINib(nibName: PageHomeCLVCell.className, bundle: nil), forCellWithReuseIdentifier: PageHomeCLVCell.className)
        loadListVideoTemp()
        buttonBack.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        buttonBack.tag = 1
        self.buttonBack.setTitle("", for: UIControl.State.normal)
        self.userProfileButton.setTitle("", for: UIControl.State.normal)
    }
    func loadListVideoTemp(){
        APIService.shared.listAllTemplateVideoSwap(page:0,categories:0){response,error in
            self.listTemplateVideo = response
            self.collectionViewGood.reloadData()
        }
    }
}

extension ListSelectSwapVideoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewPage{
            indexSelectPage = indexPath.row
            APIService.shared.listAllTemplateVideoSwap(page:indexSelectPage,categories:0){response,error in
                self.listTemplateVideo = response
                self.collectionViewGood.reloadData()
            }
            self.collectionViewPage.reloadData()
        }else{
            let vc = SwapVideoDetailVC(nibName: "SwapVideoDetailVC", bundle: nil)
            vc.itemLink = self.listTemplateVideo[indexPath.row]
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
        cell.labelName.text = self.listTemplateVideo[indexPath.row].noi_dung ?? ""
        let url = URL(string: self.listTemplateVideo[indexPath.row].thumbnail ?? "")
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

extension ListSelectSwapVideoVC: UICollectionViewDelegateFlowLayout {
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
            return CGSize(width: UIScreen.main.bounds.width/6 - 10, height: 200)
        }
        return CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
    }
}

