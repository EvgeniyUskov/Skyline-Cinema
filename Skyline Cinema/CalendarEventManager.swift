//
//  CalendarEventManager.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 17.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI
import UIKit

class CalendarEventManager: NSObject {
    let eventStore = EKEventStore()
    
    func addEventToCalendar(event: Event) {
        addEventToCalendar(title: event.title, description: "", startDate: event.startDate, endDate: event.endDate)
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                let alarm = EKAlarm(relativeOffset: TimeInterval(-60*60))
                event.addAlarm(alarm)
                DispatchQueue.main.async {
                    self.presentEventCalendarDetailModal(event: event)
                }
                //                do {
                //                    try self.eventStore.save(event, span: .thisEvent)
                //                } catch let e as NSError {
                //                    completion?(false, e)
                //                    return
                //                }
                
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func presentEventCalendarDetailModal(event: EKEvent) {
        let eventModalVC = EKEventEditViewController()
        eventModalVC.event = event
        eventModalVC.eventStore = eventStore
        eventModalVC.editViewDelegate = self
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            if let topVC = rootVC.presentedViewController {
                topVC.show(eventModalVC, sender: nil)
            }
        }
    }
}

// EKEventEditViewDelegate
extension CalendarEventManager: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

