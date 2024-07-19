//
//  VideoCollectionViewCell.swift
//  FutureLove
//
//  Created by khongtinduoc on 11/28/23.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var textMain: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        textMain.isEditable = false
    }

}
