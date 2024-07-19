//
//  Template1CLVCell.swift
//  FutureLove
//
//  Created by Lê Duy Tân on 19/7/24.
//

import UIKit

class Template1CLVCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var countView: UIButton!
    @IBOutlet weak var countComment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
            super.prepareForReuse()
        labelTitle.text = nil
        txtDate.text = nil
        descriptionLabel.text = nil
        avatarImage.image = nil
        }
    
        func configCell(model: Sukien) {
            if let url = URL(string: model.link_da_swap.asStringOrEmpty()){
                avatarImage.af.setImage(withURL: url)
            }
            descriptionLabel.text = model.noi_dung_su_kien
            labelTitle.text = model.ten_su_kien
         
            let time = self.getFormattedDate(strDate: model.real_time.asStringOrEmpty() ,
                                             currentFomat: "yyyy-MM-dd, HH:mm:ss",
                                             expectedFromat: "yyyy-MM-dd")
            txtDate.text = time
            countComment.setTitle(model.count_comment?.toString(), for: .normal)
            countView.setTitle(model.count_view?.toString(), for: .normal)
        }
    
    func configCellDetail(model: EventModel) {
        if let url = URL(string: model.link_da_swap.asStringOrEmpty()){
            avatarImage.af.setImage(withURL: url)
        }
        descriptionLabel.text = model.noi_dung_su_kien
        labelTitle.text = model.ten_su_kien
     
        let time = self.getFormattedDate(strDate: model.real_time.asStringOrEmpty() ,
                                         currentFomat: "yyyy-MM-dd, HH:mm:ss",
                                         expectedFromat: "yyyy-MM-dd")
        txtDate.text = time
        countComment.setTitle(model.count_comment?.toString(), for: .normal)
        countView.setTitle(model.count_view?.toString(), for: .normal)

    }
        
        func getFormattedDate(strDate: String , currentFomat: String, expectedFromat: String) -> String {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = currentFomat

            let date : Date = dateFormatterGet.date(from: strDate) ?? Date()

            dateFormatterGet.dateFormat = expectedFromat
            return dateFormatterGet.string(from: date)
        }
    }
