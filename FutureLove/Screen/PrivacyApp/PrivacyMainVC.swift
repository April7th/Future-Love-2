//
//  PrivacyMainVC.swift
//  FutureLove
//
//  Created by khongtinduoc on 10/22/23.
//

import UIKit

class PrivacyMainVC: UIViewController {
    @IBOutlet weak var textPrivacy: UITextView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        textPrivacy.backgroundColor = UIColor.clear
    }
}
