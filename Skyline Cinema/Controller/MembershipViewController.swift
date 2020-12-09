//
//  MembershipViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 16.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MembershipViewController: UIViewController {
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var memershipEndDateLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var membershipActiveTillLabel: UILabel!
    @IBOutlet weak var noMembershipLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        showNoMembership()
        if let plateNumber = defaults.string(forKey: Constants.propLicensePlateNumber) {
            if let membership = NetworkManager.shared.getMembershipLink(licensePlateNumber: plateNumber) {
                
                QRManager.shared.generateQrCode(membershipUrl: url.absoluteString)
            }
        }
    }
    
    //TODO: move to NetworkManager
    func getQrCodeByLink() {
        if Constants.isNetworkActive {
            AF.request(Routes.skylineCinemaMembershipURL, method: .get).responseJSON { (response) in
                switch response.result {
                        case .success:
                            let membershipDetails: [String: String] = JSONManager.shared.parseMembershipURL(response: response)
                            if let url = membershipDetails[Constants.qrURL],
                                let endDate = membershipDetails[Constants.endDate] {
                                let membership = Membership(url: url, date: endDate)
                                let qrImage = QRManager.shared.generateQrCode(membershipUrl: membership.url)
                                
                                DispatchQueue.main.async {
                                    if let qr = qrImage {
                                        self.showMembership(membership: membership, qrImage: qr)
                                    } else {
                                        self.showNoMembership()
                                    }
                                }
                            }
                        case let .failure(error):
                            print(error)
                }
            }
        }
        else {
            let membershipDetails: [String: String] = JSONManager.shared.parseMOCKMembershipURL()
                    if let url = membershipDetails[Constants.qrURL],
                        let endDate = membershipDetails[Constants.endDate] {
                        let membership = Membership(url: url, date: endDate)
                        let qrImage = QRManager.shared.generateQrCode(membershipUrl: membership.url)
                        
                        DispatchQueue.main.async {
                            if let qr = qrImage {
                                self.showMembership(membership: membership, qrImage: qr)
                            } else {
                                self.showNoMembership()
                            }
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        SVProgressHUD.show()
        showNoMembership()
        getQrCodeByLink()
        SVProgressHUD.dismiss()
    }
    
   
    
    func showNoMembership() {
        qrLabel.isHidden = true
        memershipEndDateLabel.isHidden = true
        qrImageView.isHidden = true
        membershipActiveTillLabel.isHidden = true
        noMembershipLabel.isHidden = false
    }
    
    func showMembership(membership: Membership, qrImage: UIImage) {
        qrImageView.image = qrImage
        memershipEndDateLabel.text = membership.dateString
        qrLabel.isHidden = false
        memershipEndDateLabel.isHidden = false
        qrImageView.isHidden = false
        membershipActiveTillLabel.isHidden = false
        noMembershipLabel.isHidden = true
        
    }
}
