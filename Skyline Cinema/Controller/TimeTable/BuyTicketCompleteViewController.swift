//
//  BuyTicketCompleteViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 16.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import WebKit
import SVProgressHUD
import Alamofire

class BuyTicketCompleteViewController: UIViewController {
    
    let calendarEventManager = CalendarEventManager()
    var movie: MovieViewModelProtocol!
    
    @IBOutlet weak var purchaseSuccessfullLabel: UILabel!
    @IBOutlet weak var ticketsLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var ticketToCarLabel: UILabel!

    @IBOutlet weak var addEventToCalendarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        resetUI()
        
        if let movieLocal = movie {
            let ticketRequest = TicketRequest(movie: movieLocal)
            let parameters = ticketRequest.transformToParameters()
            if Constants.isNetworkActive {
                AF.request(Routes.skylineCinemaTicketRequestURL,
                                  method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default).responseJSON { response in
                        switch response.result {
                                case .success:
                                    debugPrint(response)
                                case let .failure(error):
                                    print(error)
                                    self.setUIToErrorMode()
                                }
                }
            }
            movieImageView.sd_setImage(with: URL(string: movieLocal.imageURL ?? ""), completed: nil)
            movieNameLabel.text = movieLocal.title
            dateLabel.text = DateUtils.stringDateTimeToLiteralString(dateString: movieLocal.date)
        }
        SVProgressHUD.dismiss()
    }
    
    func resetUI() {
        purchaseSuccessfullLabel.isHidden = false
        ticketsLabel.isHidden = false
        movieNameLabel.isHidden = false
        dateLabel.isHidden = false
        movieImageView.isHidden = false
        ticketToCarLabel.isHidden = false
        ticketToCarLabel.text = Constants.ticketToCar
        addEventToCalendarButton.isHidden = false
    }

    func setUIToErrorMode() {
        purchaseSuccessfullLabel.isHidden = true
        ticketsLabel.isHidden = true
        movieNameLabel.isHidden = true
        dateLabel.isHidden = true
        movieImageView.isHidden = true
        ticketToCarLabel.isHidden = false
        ticketToCarLabel.text = Constants.ticketToCarError

        addEventToCalendarButton.isHidden = true
    }
    
    @IBAction func AddToCalendarButtonTapped(_ sender: Any) {
        let event = createEvent()
        if let event = event {
            calendarEventManager.addEventToCalendar(event: event)
        }
    }
    
    func createEvent() -> Event? {
        if let movieLocal = movie {
            let startDate = DateUtils.stringToDateTime(dateString: movieLocal.date)
            let endDate = startDate.addingTimeInterval(2 * 60 * 60)
            let event = Event(title: movie!.title, startDate: startDate , endDate: endDate)
            return event
        }
        return nil
    }

    
}
