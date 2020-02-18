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

class BuyTicketCompleteViewController: UIViewController {
    
    let eventsCalendarManager = EventsCalendarManager()
    let calendarEventManager = CalendarEventManager()
    var movie: TimeTableCellViewModel?
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        if let movieLocal = movie {
            movieImageView.sd_setImage(with: URL(string: movieLocal.imageURL ?? ""), completed: nil)
            movieNameLabel.text = movieLocal.title
            dateLabel.text = DateUtils.stringDateTimeToLiteralString(dateString: movieLocal.date)
        }
        SVProgressHUD.dismiss()
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
