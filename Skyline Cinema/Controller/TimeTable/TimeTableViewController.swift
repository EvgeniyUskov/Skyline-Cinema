//
//  TimeTableViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10/06/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class TimeTableViewController: UIViewController {
    
    @IBOutlet weak var timeTableTableView: UITableView!
    
    var viewModel: TimeTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        NetworkManager.shared.getMovies(completion: {
            [unowned self]
            movieDays in
            self.viewModel = TimeTableViewModel(movieDays: movieDays)
                SVProgressHUD.dismiss()
        })
        setupTableView()
    }
    
    func setupTableView() {
        timeTableTableView.delegate = self
        timeTableTableView.dataSource = self
        timeTableTableView.register(UINib(nibName: "TimeTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        timeTableTableView.rowHeight = 150
        timeTableTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMovieDetails" {
            
            let destinationVC = segue.destination as! MovieDetailsViewController
            
            if let indexPath = timeTableTableView.indexPathForSelectedRow {
                destinationVC.movie = viewModel.movieDays[indexPath.section].movies[indexPath.row]
            }
        }
    }

}

extension TimeTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableView Implementation methods
      func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.movieDays.count
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieDays[section].movies.count
      }
      
      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.movieDays[section].date
      }
      
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let groupLabel = UILabel()
          if section == 0 {
              groupLabel.frame = CGRect(x: 10, y: 15, width: 200, height: 20)
          }
          else {
              groupLabel.frame = CGRect(x: 10, y: 0, width: 200, height: 20)
          }
          groupLabel.font = UIFont.systemFont(ofSize: 22)
        groupLabel.textColor = UIColor.white
          groupLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
          
          let headerView = UIView()
          headerView.layer.cornerRadius = CGFloat(10.0)
          headerView.addSubview(groupLabel)
          
          return headerView
      }
      
      // show data on table row
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = timeTableTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! TimeTableViewCell
        let movie = viewModel.movieDays[indexPath.section].movies[indexPath.row]
          
          cell.setUp(viewModel: movie)
          return cell
      }
      
      //UITableViewCell click
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          performSegue(withIdentifier: "goToMovieDetails", sender: self)
      }
    
}
