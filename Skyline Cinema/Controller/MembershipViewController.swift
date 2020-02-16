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
    
    let networkManager = NetworkManager()
    let jsonManager = JSONManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        showNoMembership()
        
        getQrCodeByLink()
        SVProgressHUD.dismiss()
    }
    
    func getQrCodeByLink() {
        let networkActive = false
        if networkActive {
            Alamofire.request(networkManager.skylineCinemaMembershipURL, method: .get).responseJSON { (response) in
                if response.result.isSuccess {
                    let membershipDetails: [String: String] = self.jsonManager.parseMembershipURL(response: response)
                    if let url = membershipDetails[Constants.qrURL],
                        let endDate = membershipDetails[Constants.endDate] {
                        let membership = Membership(url: url, date: endDate)
                        let qrImage = self.generateQrCode(membershipUrl: membership.url)
                        
                        DispatchQueue.main.async {
                            if let qr = qrImage {
                                self.showMembership(membership: membership, qrImage: qr)
                            } else {
                                self.showNoMembership()
                            }
                        }
                    }
                }
            }
        }
        else {
                    let membershipDetails: [String: String] = self.jsonManager.parseMOCKMembershipURL()
                    if let url = membershipDetails[Constants.qrURL],
                        let endDate = membershipDetails[Constants.endDate] {
                        let membership = Membership(url: url, date: endDate)
                        let qrImage = self.generateQrCode(membershipUrl: membership.url)
                        
                        DispatchQueue.main.async {
                            if let qr = qrImage {
                                self.showMembership(membership: membership, qrImage: qr)
                            } else {
                                self.showNoMembership()
                            }
                }
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        SVProgressHUD.show()
        showNoMembership()
        getQrCodeByLink()
        SVProgressHUD.dismiss()
    }
    
    func generateQrCode(membershipUrl: String) -> UIImage?{
        let data = membershipUrl.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return nil}
        
        let transform = CGAffineTransform(scaleX: 7, y: 7)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        return UIImage(ciImage: scaledQrImage)
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
