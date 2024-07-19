//
//  SKLoveVC.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 29/01/2024.
//

import UIKit
import SETabView

class SKLoveVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SETabItemProvider {
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_video(), tag: 0)
    }
    @IBOutlet weak var plusNam: UIImageView!
    @IBOutlet weak var plusNu: UIImageView!
    @IBOutlet weak var imageNam: UIImageView!
    @IBOutlet weak var imageNu: UIImageView!
    @IBOutlet weak var imageLove: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var boyNameTextField: UITextField!
    @IBOutlet weak var girlNameTextField: UITextField!
    let spinner = UIActivityIndicatorView(style: .large)
    var image_Data_Nam:UIImage = UIImage()
    var image_Data_Nu:UIImage = UIImage()
    var imageboyLink: String = ""
    var imageGirlLink: String = ""
    var selectedImageView: UIImageView?
    var uploadImageView: UIImageView?
    var currentImageType: ChooseImageType = .boy
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
        
        let tapGestureNam = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        plusNam.isUserInteractionEnabled = true
        plusNam.addGestureRecognizer(tapGestureNam)
        let tapGestureNam2 = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        imageNam.isUserInteractionEnabled = true
        imageNam.addGestureRecognizer(tapGestureNam2)

        let tapGestureNu = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        plusNu.isUserInteractionEnabled = true
        plusNu.addGestureRecognizer(tapGestureNu)
        let tapGestureNu2 = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        imageNu.isUserInteractionEnabled = true
        imageNu.addGestureRecognizer(tapGestureNu2)

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
                plusNam.isHidden = true
                self.detectFaces(in: selectedImage)
            } else {
                picker.dismiss(animated: true)
                plusNu.isHidden = true
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
                    self.imageboyLink = OldBoyLink
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
        spinner.center = view.center

        // Thêm spinner vào view
        view.addSubview(spinner)

        // Bắt đầu hiển thị spinner
        spinner.startAnimating()
        let OldGirlLink2 = self.imageGirlLink.replace(target: "https://futurelove.online", withString:"/var/www/build_futurelove")
        let OldBoyLink2 =  self.imageboyLink.replace(target: "https://futurelove.online", withString:"/var/www/build_futurelove")
        self.imageNu.image = self.image_Data_Nam
        self.imageNam.image = self.image_Data_Nu
        guard self.boyNameTextField.text != "" && self.girlNameTextField.text != ""  else {

            return
        }

        var timeCount = 0.0
 
        self.btnStart.isEnabled = false

        APIService.shared.getEventsAPI(linkNam: OldBoyLink2, linkNu: OldGirlLink2,device: AppConstant.modelName ?? "iphone", ip: AppConstant.IPAddress.asStringOrEmpty(), Id: AppConstant.userId.asStringOrEmpty(), tennam: self.boyNameTextField.text.asStringOrEmpty(), tennu: self.girlNameTextField.text.asStringOrEmpty()){ result, error in
            if let success = result{
                self.hideCustomeIndicator()
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
                            //                            itemAdd.id_template = indexList.id_template
                            itemAdd.link_nam_chua_swap = indexList.nam
                            itemAdd.link_nu_chua_swap = indexList.nu
                            itemAdd.link_nu_goc = indexList.nam
                            itemAdd.link_nam_goc = indexList.nu
                            itemAdd.noi_dung_su_kien = indexList.thongtin
                            itemAdd.so_thu_tu_su_kien = sothutu_sukien
                            sothutu_sukien = sothutu_sukien + 1
                            //                            itemAdd.phantram_loading = indexList.phantram_loading

                            //                            itemAdd.so_thu_tu_su_kien = indexList.so_thu_tu_su_kien
                            //                            itemAdd.ten_nam = indexList.ten_nam
                            //                            itemAdd.ten_nu = indexList.ten_nu
                            itemAdd.ten_su_kien = indexList.tensukien
                            dataDetail.append(itemAdd)
                        }
                        let idSukienPro = success.sukien[0].id_toan_bo_su_kien ?? "0"
                        vc.idToanBoSuKien = Int(idSukienPro ) ?? 0
                        vc.dataDetail = dataDetail

                        APIService.shared.getEventsAPISuKienNgam(linkNam: OldBoyLink2, linkNu: OldGirlLink2,device: AppConstant.modelName ?? "iphone", ip: AppConstant.IPAddress.asStringOrEmpty(), Id: AppConstant.userId.asStringOrEmpty(), tennam: self.boyNameTextField.text.asStringOrEmpty(), tennu: self.girlNameTextField.text.asStringOrEmpty()){ result, error in
                            if let success = result{
                                self.spinner.stopAnimating()
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                        }

                    }
                }
            }
            print("DoneSk")
        }


    }


}
extension SKLoveVC {
    enum ChooseImageType {
        case boy
        case girl
    }
}




