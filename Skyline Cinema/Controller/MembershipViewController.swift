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
            getQRCode(licencePlateNumber: plateNumber)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        SVProgressHUD.show()
        showNoMembership()
        if let plateNumber = defaults.string(forKey: Constants.propLicensePlateNumber) {
            getQRCode(licencePlateNumber: plateNumber)
        }
        SVProgressHUD.dismiss()
    }
    
    func getQRCode(licencePlateNumber: String) {
        NetworkManager.shared.getMembership(licensePlateNumber: licencePlateNumber,
                                            completion: { (membership) in
                                                let qrImage = QRManager.shared.generateQrCode(membershipUrl: membership.url)
                                                if let qr = qrImage {
                                                    self.showMembership(membership: membership, qrImage: qr)
                                                } else {
                                                    self.showNoMembership()
                                                }
                                                SVProgressHUD.dismiss()
                                            })
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
