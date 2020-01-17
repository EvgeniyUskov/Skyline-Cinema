//
//  MembershipViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 16.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import Alamofire

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
        showNoMembership()
        
        getQrCodeByLink()
    }
    
    func getQrCodeByLink() {
        let networkActive = false
        if networkActive {
            Alamofire.request(networkManager.membershipURL, method: .get).responseJSON { (response) in
                if response.result.isSuccess {
                    let membershipDetails: [String: String] = self.jsonManager.parseMembershipURL(response: response)
                    if let url = membershipDetails[Constants.shared.qrURL],
                        let endDate = membershipDetails[Constants.shared.endDate] {
                        let membership = Membership(url: url, date: endDate)
                        let qrImage = self.generteQrCode(membershipUrl: membership.url)
                        
                        DispatchQueue.main.async {
                            if let qr = qrImage {
                                self.setUp(membership: membership, qrImage: qr)
                            }
                        }
                    }
                }
            }
        }
        else {
                    let membershipDetails: [String: String] = self.jsonManager.parseMOCKMembershipURL()
                    if let url = membershipDetails[Constants.shared.qrURL],
                        let endDate = membershipDetails[Constants.shared.endDate] {
                        let membership = Membership(url: url, date: endDate)
                        let qrImage = self.generteQrCode(membershipUrl: membership.url)
                        
                        DispatchQueue.main.async {
                            if let qr = qrImage {
                                self.setUp(membership: membership, qrImage: qr)
                            }
                }
            }
        }
    }
    
    func generteQrCode(membershipUrl: String) -> UIImage?{
        let data = membershipUrl.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return nil}
        return UIImage(ciImage: qrImage)
    }
    
    func getQrCodeByImage() {
        
    }
    
    func setUp(membership: Membership, qrImage: UIImage){
        showMembership(membership: membership, qrImage: qrImage)
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
        membershipActiveTillLabel.text = membership.dateString
        qrLabel.isHidden = false
        memershipEndDateLabel.isHidden = false
        qrImageView.isHidden = false
        membershipActiveTillLabel.isHidden = false
        noMembershipLabel.isHidden = true
        
    }
}
