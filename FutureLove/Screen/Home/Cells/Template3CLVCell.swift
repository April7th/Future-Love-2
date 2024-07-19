//
//  Template3CLVCell.swift
//  FutureLove
//
//  Created by Lê Duy Tân on 19/7/24.
//

import UIKit
import Kingfisher

class Template3CLVCell: UICollectionViewCell {

    @IBOutlet weak var imageCoverPro: UIImageView!
    @IBOutlet weak var CountView: UIButton!
    @IBOutlet weak var countComment: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    func configCell(model: Sukien) {
//        if let url = URL(string: model.link_da_swap.asStringOrEmpty()){
//            titleImage.af.setImage(withURL: url)
//        }
        descriptionLabel.text = model.noi_dung_su_kien
        nameLabel.text = model.ten_su_kien
     
        let time = self.getFormattedDate(strDate: model.real_time.asStringOrEmpty() ,
                                         currentFomat: "yyyy-MM-dd, HH:mm:ss",
                                         expectedFromat: "yyyy-MM-dd")
        dateLabel.text = time
        countComment.setTitle(model.count_comment?.toString(), for: .normal)
        CountView.setTitle(model.count_view?.toString(), for: .normal)
        
        let url = URL(string: model.link_da_swap ?? "")
        let processor = DownsamplingImageProcessor(size: imageCoverPro.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        imageCoverPro.kf.indicatorType = .activity
        imageCoverPro.kf.setImage(
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
    }
    func configCellDetail(model: EventModel) {
//        if let url = URL(string: model.link_da_swap.asStringOrEmpty()){
//            avatarImage.af.setImage(withURL: url)
//        }
        descriptionLabel.text = model.noi_dung_su_kien
        nameLabel.text = model.ten_su_kien
     
        let time = self.getFormattedDate(strDate: model.real_time.asStringOrEmpty() ,
                                         currentFomat: "yyyy-MM-dd, HH:mm:ss",
                                         expectedFromat: "yyyy-MM-dd")
        dateLabel.text = time
        countComment.setTitle(model.count_comment?.toString(), for: .normal)
        CountView.setTitle(model.count_view?.toString(), for: .normal)

        let url = URL(string: model.link_da_swap ?? "")
        let processor = DownsamplingImageProcessor(size: imageCoverPro.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        imageCoverPro.kf.indicatorType = .activity
        imageCoverPro.kf.setImage(
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
    }
    
    func getFormattedDate(strDate: String , currentFomat: String, expectedFromat: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat

        let date : Date = dateFormatterGet.date(from: strDate) ?? Date()

        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }
}
