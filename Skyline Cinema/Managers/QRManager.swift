//
//  QRManager.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 09.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit

struct QRManager {
    static var shared : QRManager {
        return QRManager()
    }
    
    private init(){}
    
    func generateQrCode(membershipUrl: String) -> UIImage?{
        let data = membershipUrl.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return nil}
        
        let transform = CGAffineTransform(scaleX: 7, y: 7)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        return UIImage(ciImage: scaledQrImage)
    }
}
