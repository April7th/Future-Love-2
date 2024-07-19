import UIKit
import Photos

protocol CellSwap2Delegate: AnyObject {
    func didSelectVideoURL(_ videoURL: URL?)
}

class CellSwap2: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var imageUpdate: UIImageView!
    @IBOutlet weak var imageNew: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    let spinner = UIActivityIndicatorView(style: .large)

    weak var delegate: CellSwap2Delegate?

    var resultt : String?
    var videoURL: String?
    var videoURLDownload : URL?
    var idVideo: Int?
    var selectedImageView: UIImageView?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureImageView(imageThumb)
        configureImageView(imageNew)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped))
        imageNew.isUserInteractionEnabled = true
        imageNew.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageUpdateTapped))
        imageUpdate.isUserInteractionEnabled = true
        imageUpdate.addGestureRecognizer(tapGesture2)
        btnStart.isEnabled = false
        btnDownload.isEnabled = false
    }

    private func configureImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 49 // Half of your desired diameter
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 98),
            imageView.heightAnchor.constraint(equalToConstant: 98)
        ])
    }
    @objc func imageUpdateTapped() {
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
    func videoURL(_ url: URL?, _ id: Int?) {
        if let url = url {
            videoURL = url.absoluteString.removingPercentEncoding
            print("VideoURL: \(videoURL)")
        }
        idVideo = id
        print("ID video \(idVideo)")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageNew.image = selectedImage
            uploadGenVideoByImages(selectedImage) { (result, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                } else {
                    print("Image uploaded successfully: \(result)")
                    self.imageUpdate.isHidden = true
                    self.btnStart.isEnabled = true
                    if let rs = result as? String {
                        self.resultt = rs
                    }

                }
            }
        }
        UIViewController().dismiss(animated: true, completion: nil)
    }
    func createVideo(imageLink: String, videoLink: String, completion: @escaping (_ response: SukienSwapVideo?, _ error: Error?) -> Void) {

        print(AppConstant.modelName ?? "iphone")
        print(AppConstant.IPAddress.asStringOrEmpty() )
        print(AppConstant.userId.asStringOrEmpty() )

        APIService.shared.createVideoFromImagesAndVideo(device_them_su_kien: AppConstant.modelName ?? "iphone", id_video: String(self.idVideo ?? 0) , ip_them_su_kien: AppConstant.IPAddress.asStringOrEmpty(), id_user: AppConstant.userId.asStringOrEmpty(), link_img: imageLink, ten_video: "swapvideo.mp4"){(response, error) in
            if let error = error {
                print("Error creating video: \(error)")
            } else {

                print("Video created successfully: \(response)")
                // Xử lý kết quả video ở đây
                
                completion(response, nil)
                if let response = response {
                    self.videoURLDownload = response.linkVidSwap.flatMap { URL(string: $0) }
                    //print(response.linkVidSwap.flatMap { URL(string: $0) })
                    if let videoURLDownload = self.videoURLDownload {
                        self.delegate?.didSelectVideoURL(videoURLDownload)
                    }
                    self.btnDownload.isEnabled = true
                }
                self.spinner.stopAnimating()
            }

        }
    }

    @IBAction func btnStartClick(_ sender: Any) {
        if let imageUrl = resultt as? String {
            self.createVideo(imageLink: imageUrl, videoLink: self.videoURL!) { (resultVideo, error) in
                if let error = error {
                    //print("Error creating video: \(error)")
                } else {
                    //print("Video created successfully: \(resultVideo)")
                    // Xử lý kết quả video ở đây
                    if let topViewController = UIApplication.topViewController() {
                        self.spinner.center = topViewController.view.center
                        topViewController.view.addSubview(self.spinner)
                        self.spinner.startAnimating()
                    }

                }
            }
        }
    }
    @IBAction func btnDowloadClick(_ sender: Any) {
        guard let videoURLDownload = videoURLDownload else {
            print("Video URL is nil.")
            return
        }

        downloadVideo(from: videoURLDownload)
    }
    
    func downloadVideo(from url: URL) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { (temporaryURL, response, error) in
            guard let temporaryURL = temporaryURL else {
                print("Download failed. Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Lưu trữ video vào local storage (ví dụ: Documents directory)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //let destinationURL = documentsDirectory.appendingPathComponent("downloadedVideo.mp4")
            let timestamp = Date().timeIntervalSince1970
            let videoName = "downloadedVideo_\(timestamp).mp4"
            let destinationURL = documentsDirectory.appendingPathComponent(videoName)
            do {
                try FileManager.default.moveItem(at: temporaryURL, to: destinationURL)
                print("Downloaded video saved to: \(destinationURL.absoluteString)")

                // Lưu video vào thư viện ảnh
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationURL.path) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationURL.path, nil, nil, nil)
                }
            } catch {
                print("Failed to move downloaded file. Error: \(error.localizedDescription)")
            }
        }

        downloadTask.resume()  
    }
    func uploadGenVideoByImages(_ image: UIImage, completion: @escaping ApiCompletion){

        APIService.shared.UploadImagesToGenRieng("https://databaseswap.mangasocial.online/upload-gensk/" + String(AppConstant.userId ?? 0) + "?type=src_vid", ImageUpload: image, method: .POST, loading: true){data,error in
            completion(data, nil)
        }
    }
    
}
extension UIResponder {
    func findViewController() -> UIViewController? {
        if let viewController = self as? UIViewController {
            return viewController
        } else if let nextResponder = self.next {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
