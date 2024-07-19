//
//  SwapImageImageVC.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 29/01/2024.
//

import UIKit
import SETabView
import Photos
class SwapImageImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SETabItemProvider {
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_video(), tag: 0)
    }

    @IBOutlet weak var plush1: UIImageView!
    @IBOutlet weak var plush2: UIImageView!
    @IBOutlet weak var imageUpload1: UIImageView!
    @IBOutlet weak var imageUpload2: UIImageView!
    @IBOutlet weak var imageSwap: UIImageView!
    @IBOutlet weak var backGroundBtn: UIImageView!
    @IBOutlet weak var backGroundBtnSave: UIImageView!
    @IBOutlet weak var backGroundBtnDowload: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    let spinner = UIActivityIndicatorView(style: .large)
    var imageSwapUrl: String = ""
    var uploadImageView: UIImageView?
    var selectedImageView: UIImageView?
    var currentImageType: CheckImageType = .first
    var image_Data_1:UIImage = UIImage()
    var image_Data_2:UIImage = UIImage()
    var image1Link: String = ""
    var image2Link: String = ""
    var checkNam: Bool = false
    var checkNu: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.isHidden = true
        btnDownload.isHidden = true
        backGroundBtnSave.isHidden = true
        backGroundBtnDowload.isHidden = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.main.bounds
        gradientLayer.colors = [
            UIColor(red: 229/255.0, green: 166/255.0, blue: 190/255.0, alpha: 1.0).cgColor,
            UIColor(red: 171/255.0, green: 122/255.0, blue: 203/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        plush1.isUserInteractionEnabled = true
        plush1.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        plush2.isUserInteractionEnabled = true
        plush2.addGestureRecognizer(tapGesture2)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        imageUpload1.isUserInteractionEnabled = true
        imageUpload1.addGestureRecognizer(tapGesture3)
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped(_:)))
        imageUpload2.isUserInteractionEnabled = true
        imageUpload2.addGestureRecognizer(tapGesture4)
    }
    @objc func imageUpdateTapped(_ sender: UITapGestureRecognizer) {
        // Xác định ImageView tương ứng với sự kiện tap
        if sender.view == plush1 || sender.view == imageUpload1 {
            selectedImageView = plush1
            currentImageType = .first
            uploadImageView = imageUpload1

        } else if sender.view == plush2 || sender.view == imageUpload2 {
            selectedImageView = plush2
            currentImageType = .second
            uploadImageView = imageUpload2

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
            if self.currentImageType == .first {
                picker.dismiss(animated: true)
                plush1.isHidden = true
                self.detectFaces(in: selectedImage)
            } else {
                picker.dismiss(animated: true)
                plush2.isHidden = true
                self.detectFaces(in: selectedImage)
            }
            uploadImageView?.image = selectedImage
            configureImageView(uploadImageView!)
            picker.dismiss(animated: true, completion: nil)
            unreplaceBtn()
        } else {
            print("Image not found")
        }

    }
    func detectFaces(in image: UIImage)  {

        if self.currentImageType == .first {
            self.imageUpload1.image = UIImage(named: "icon-upload")
            self.uploadGenLoveByImages(is1: true, image_Data: image){data,error in
                if let data = data as? String{
                    let Old1Link = data//.replacingOccurrences(of: "/var/www/build_futurelove", with: "https://futurelove.online")
                    print("1: \(Old1Link)")
                    self.image1Link = Old1Link
                    self.checkNam = true
                }
            }
        }else{
            self.imageUpload2.image = UIImage(named: "icon-upload")
            self.uploadGenLoveByImages(is1: false, image_Data: image){data,error in
                if let data = data as? String{
                    let Old2Link = data//.replacingOccurrences(of: "/var/www/build_futurelove", with: "https://futurelove.online")
                    print("2: \(Old2Link)")
                    self.image2Link = Old2Link
                    self.checkNu = true
                }
            }
        }

    }

    func uploadGenLoveByImages(is1:Bool,image_Data:UIImage,completion: @escaping ApiCompletion){
        APIService.shared.UploadImagesToGenRieng("https://databaseswap.mangasocial.online/upload-gensk/" + String(AppConstant.userId ?? 0) + "?type=src_vid", ImageUpload: image_Data,method: .POST, loading: true){data,error in
            print("uploadding")
            completion(data, nil)
            print("done")
            if let error = error {
                self.showAlert(title: "Lỗi", message: "Vui lòng tải lên ảnh hợp lệ (Rõ khuôn mặt)")
            }
        }
    }
    private func configureImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 8 // Half of your desired diameter
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 121),
            imageView.heightAnchor.constraint(equalToConstant: 142)
        ])
    }

    func createSwapImage(image1Link: String, image2Link: String, completion: @escaping (_ response: SukienSwap2Image?, _ error: Error?) -> Void){
        print("Start")
        APIService.shared.createImageFrom2Image(device_them_su_kien: AppConstant.modelName ?? "iphone", ip_them_su_kien: AppConstant.IPAddress.asStringOrEmpty(), id_user: AppConstant.userId.asStringOrEmpty(), link_img1: image1Link, link_img2: image2Link){(response, error) in
            if let error = error {
                print("Erro create image: \(error)")
            } else {
                print("Done: \(response)")

                if let urlString = response?.link_da_swap, let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.imageSwapUrl = urlString
                                self.imageSwap.image = image
                                self.spinner.stopAnimating()
                                self.replaceBtn()
                            }
                        }
                    }.resume()
                }
            }

        }

    }
    func replaceBtn(){
        btnStart.isHidden = true
        backGroundBtn.isHidden = true
        btnSave.isHidden = false
        btnDownload.isHidden = false
        backGroundBtnSave.isHidden = false
        backGroundBtnDowload.isHidden = false
    }
    func unreplaceBtn(){
        btnStart.isHidden = false
        backGroundBtn.isHidden = false
        btnSave.isHidden = true
        btnDownload.isHidden = true
        backGroundBtnSave.isHidden = true
        backGroundBtnDowload.isHidden = true
    }
    @IBAction func startEventBtn(_ sender: Any){
        if(!checkNu && !checkNam){
            showAlert(title: "Lỗi", message: "Vui lòng tải lên đủ ảnh hoặc ảnh hợp lệ")
        }
        else{
            print(image1Link)
            spinner.center = view.center
            view.addSubview(spinner)
            spinner.startAnimating()
            createSwapImage(image1Link: image1Link, image2Link: image2Link){ (resultVideo, error) in
                if let error = error {
                    //print("Error creating video: \(error)")
                } else {
                    
                }
            }
        }
    }
    
    @IBAction func dowloadEventBtn(_ sender: Any){
        guard let imageUrl = URL(string: imageSwapUrl) else {
            return
        }

        // Tải xuống dữ liệu hình ảnh từ URL
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                print("Lỗi tải xuống ảnh: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Dữ liệu ảnh không hợp lệ.")
                return
            }

            // Lưu ảnh vào thư viện ảnh của thiết bị
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }.resume()
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Lỗi khi lưu ảnh vào thư viện: \(error.localizedDescription)")

            // Hiển thị thông báo khi lưu thất bại
            showAlert(title: "Lỗi", message: "Không thể lưu ảnh. Vui lòng thử lại.")
        } else {
            print("Lưu ảnh thành công.")

            // Hiển thị thông báo khi lưu thành công
            showAlert(title: "Thành công", message: "Ảnh đã được lưu vào thư viện.")
        }
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageSwap.image else { return }
        let activityController =
        UIActivityViewController(activityItems: [image],
                                 applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView =
        sender
        present(activityController, animated: true, completion: nil)
    }

}

extension SwapImageImageVC {
    enum CheckImageType {
        case first
        case second
    }
}
