//
//  ListAccountVC.swift
//  FutureLove
//
//  Created by khongtinduoc on 10/29/23.
//

import UIKit
import SwiftKeychainWrapper

struct AccountLoginPro{
    var accountEmail:String = ""
    var Pass:String = ""
    var dateTime:String = ""
}

class ListAccountVC: UIViewController {
    @IBOutlet weak var collectionViewGood: UICollectionView!
    var listAccount:[AccountLoginPro] = [AccountLoginPro]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewGood.register(UINib(nibName: ListAccountCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ListAccountCollectionViewCell.className)
        if let number_user: Int = KeychainWrapper.standard.integer(forKey: "saved_login_account"){
            for item in 0..<number_user{
                var itemAdd :AccountLoginPro = AccountLoginPro()
                let emailUserKey = "email_login_" + String(item + 1)
                if let emailUser: String = KeychainWrapper.standard.string(forKey: emailUserKey){
                    itemAdd.accountEmail = emailUser
                }
                let idPassUser = "pass_login_" + String(item + 1)
                if let passEmail: String = KeychainWrapper.standard.string(forKey: idPassUser){
                    itemAdd.Pass = passEmail
                }
                let idTimeUser = "time_login_" + String(item + 1)
                if let timeLogin: String = KeychainWrapper.standard.string(forKey: idTimeUser){
                    itemAdd.dateTime = timeLogin
                }
                listAccount.append(itemAdd)
            }
            collectionViewGood.reloadData()
        }
    }
    @IBAction func BackApp(){
        self.dismiss(animated: true)
    }
}
extension ListAccountVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        KeychainWrapper.standard.set(listAccount[indexPath.row].accountEmail, forKey: "email_login_temp")
        KeychainWrapper.standard.set(listAccount[indexPath.row].Pass, forKey: "pass_login_temp")
        KeychainWrapper.standard.set(listAccount[indexPath.row].dateTime, forKey: "time_login_temp")
        self.dismiss(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listAccount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListAccountCollectionViewCell.className, for: indexPath) as! ListAccountCollectionViewCell
        cell.labelAccount.text = listAccount[indexPath.row].accountEmail
        cell.labelTime.text = listAccount[indexPath.row].dateTime
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
}

extension ListAccountVC: UICollectionViewDelegateFlowLayout {
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
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width - 5, height: 50)
        }
        return CGSize(width: UIScreen.main.bounds.width - 5, height: 50)
    }
}

