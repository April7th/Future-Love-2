//
//  SKLoveCell2.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 26/01/2024.
//

import UIKit
import SETabView
import Vision
import Toast_Swift
import DeviceKit
import HGCircularSlider
import SwiftKeychainWrapper
import SwiftVideoBackground
import WCLShineButton
import AVFoundation
import Kingfisher
import StoreKit

class SKLoveCell2: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var plusNam: UIImageView!
    @IBOutlet weak var plusNu: UIImageView!
    @IBOutlet weak var imageNam: UIImageView!
    @IBOutlet weak var imageNu: UIImageView!
    @IBOutlet weak var imageLove: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var boyNameTextField: UITextField!
    @IBOutlet weak var girlNameTextField: UITextField!
    weak var delegate: SKLoveCell2Delegate?
    var image_Data_Nam:UIImage = UIImage()
    var image_Data_Nu:UIImage = UIImage()
    var imageboyLink: String = ""
    var imageGirlLink: String = ""
    var selectedImageView: UIImageView?
    var uploadImageView: UIImageView?
    var currentImageType: ChooseImageType = .boy
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureNam = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        plusNam.isUserInteractionEnabled = true
        plusNam.addGestureRecognizer(tapGestureNam)

        let tapGestureNu = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        plusNu.isUserInteractionEnabled = true
        plusNu.addGestureRecognizer(tapGestureNu)
    }

    @objc func imageUpdateTapped(_ sender: UITapGestureRecognizer) {
        // Xác định ImageView tương ứng với sự kiện tap
        if sender.view == plusNam {
            selectedImageView = plusNam
            currentImageType = .boy
            uploadImageView = imageNam
        } else if sender.view == plusNu {
            selectedImageView = plusNu
            currentImageType = .girl
            uploadImageView = imageNu
        }

        showImagePicker()
    }

    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        if let viewController = self.findViewController() {
            viewController.present(imagePicker, animated: true, completion: nil)
        }

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Thay thế ảnh vào ImageView tương ứng

            if self.currentImageType == .boy {
                picker.dismiss(animated: true)
                self.detectFaces(in: selectedImage)
            } else {
                picker.dismiss(animated: true)
                self.detectFaces(in: selectedImage)
            }
            uploadImageView?.image = selectedImage
            configureImageView(uploadImageView!)
            picker.dismiss(animated: true, completion: nil)
        } else {
            print("Image not found")
        }

    }

    private func configureImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 42 // Half of your desired diameter
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 84),
            imageView.heightAnchor.constraint(equalToConstant: 84)
        ])
    }

    func detectFaces(in image: UIImage)  {

        if self.currentImageType == .boy {
            self.imageNam.image = UIImage(named: "icon-upload")
            self.uploadGenLoveByImages(isNam: true, image_Data: image){data,error in
                if let data = data as? String{
                    let OldBoyLink = data.replacingOccurrences(of: "/var/www/build_futurelove", with: "https://futurelove.online")
                    print("B: \(OldBoyLink)")
                    self.imageGirlLink = OldBoyLink
                    self.image_Data_Nam = image
                }
            }
        }else{
            self.imageNu.image = UIImage(named: "icon-upload")
            self.uploadGenLoveByImages(isNam: false, image_Data: image){data,error in
                if let data = data as? String{
                    let OldGirlLink = data.replacingOccurrences(of: "/var/www/build_futurelove", with: "https://futurelove.online")
                    print("G: \(OldGirlLink)")
                    self.imageGirlLink = OldGirlLink
                    self.image_Data_Nu = image
                }
            }
            self.image_Data_Nu = image
        }

    }
    func uploadGenLoveByImages(isNam:Bool,image_Data:UIImage,completion: @escaping ApiCompletion){
        var checkNamNu = ""
        if isNam == true{
            checkNamNu = "?type=src_nam"
        }else{
            checkNamNu = "?type=src_nu"
        }
        APIService.shared.UploadImagesToGenRieng("https://databaseswap.mangasocial.online/upload-gensk/" + String(AppConstant.userId ?? 0) + checkNamNu, ImageUpload: image_Data,method: .POST, loading: true){data,error in
            print("uploadding")
            completion(data, nil)
            print("done")
        }
    }
    @IBAction func startEventBtn(_ sender: Any) {
        print("Click")
        let OldGirlLink2 = self.imageGirlLink.replace(target: "https://futurelove.online", withString:"/var/www/build_futurelove")
        let OldBoyLink2 =  self.imageboyLink.replace(target: "https://futurelove.online", withString:"/var/www/build_futurelove")
        self.imageNu.image = self.image_Data_Nam
        self.imageNam.image = self.image_Data_Nu
        guard self.boyNameTextField.text != "" && self.girlNameTextField.text != ""  else {
//            if self.imageGirlLink == "" {
//                self.animateViewAll(viewAnim: self.girlView)
//                self.view.makeToast("Please select Photo girl", position: .top)
//                self.IsStopGirlAnimation = false
//            }else if self.imageboyLink == "" {
//                self.animateViewAll(viewAnim: self.boyView)
//                self.view.makeToast("Please select Boy girl", position: .top)
//                self.IsStopBoyAnimation = false
//            } else if self.boyNameTextField.text == "" || self.girlNameTextField.text == "" {
//                self.view.makeToast("Please Fill Text Name For Boy And Girl", position: .top)
//            }
            return
        }
//        try? VideoBackground.shared.play(view: self.backgroundView, videoName: "background2", videoType: "mp4")
        //self.showCustomeIndicator()
        //self.circularSlider.maximumValue = 180.0
        var timeCount = 0.0
//        self.timerNow = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
//            timeCount = timeCount + 1
//            let tile = Int((timeCount / 180.0) * 100.0)
//            self.percentLabel.text = String(tile) + " %"
//            self.updatePlayerUI(withCurrentTime: CGFloat(timeCount))
//        }
        self.btnStart.isEnabled = false

        APIService.shared.getEventsAPI(linkNam: OldBoyLink2, linkNu: OldGirlLink2,device: AppConstant.modelName ?? "iphone", ip: AppConstant.IPAddress.asStringOrEmpty(), Id: AppConstant.userId.asStringOrEmpty(), tennam: self.boyNameTextField.text.asStringOrEmpty(), tennu: self.girlNameTextField.text.asStringOrEmpty()){ result, error in
            if let success = result{
                //self.hideCustomeIndicator()
                if let id_toan_bo_su_kien = Int((success.sukien.first?.id_toan_bo_su_kien ?? "0")){
                    if id_toan_bo_su_kien > 0{
                        self.btnStart.isEnabled = true
                        let data = id_toan_bo_su_kien
                        let vc = EventViewController(data: data)
                        var dataDetail: [EventModel] = [EventModel]()
                        var sothutu_sukien = 1
                        for indexList in success.sukien{
                            var itemAdd:EventModel = EventModel()
                            itemAdd.link_da_swap = indexList.link_img
                            itemAdd.count_comment = 0
                            itemAdd.count_view = 0
                            itemAdd.id = Int(indexList.id ?? "0")
                            itemAdd.id_user = indexList.id_num
                            let dateNow = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
                            let dateString = dateFormatter.string(from:dateNow)
                            itemAdd.real_time = dateString
                            itemAdd.link_nam_chua_swap = indexList.nam
                            itemAdd.link_nu_chua_swap = indexList.nu
                            itemAdd.link_nu_goc = indexList.nam
                            itemAdd.link_nam_goc = indexList.nu
                            itemAdd.noi_dung_su_kien = indexList.thongtin
                            itemAdd.so_thu_tu_su_kien = sothutu_sukien
                            sothutu_sukien = sothutu_sukien + 1
                            itemAdd.ten_su_kien = indexList.tensukien
                            dataDetail.append(itemAdd)
                        }
                        let idSukienPro = success.sukien[0].id_toan_bo_su_kien ?? "0"
                        vc.idToanBoSuKien = Int(idSukienPro ) ?? 0
                        vc.dataDetail = dataDetail

                        APIService.shared.getEventsAPISuKienNgam(linkNam: OldBoyLink2, linkNu: OldGirlLink2,device: AppConstant.modelName ?? "iphone", ip: AppConstant.IPAddress.asStringOrEmpty(), Id: AppConstant.userId.asStringOrEmpty(), tennam: self.boyNameTextField.text.asStringOrEmpty(), tennu: self.girlNameTextField.text.asStringOrEmpty()){ result, error in
                            if let success = result{
                            }
                        }
                        //self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
            print("DoneSk")
        }


    }
    

}
extension SKLoveCell2 {
    enum ChooseImageType {
        case boy
        case girl
    }
}
protocol SKLoveCell2Delegate: AnyObject {
    func didTapButton(in cell: SKLoveCell2)
}
