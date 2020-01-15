//
//  TimeTableViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10/06/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class TimeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timeTableTableView: UITableView!
    let realm = try! Realm()
    
    var movieViewModelList = [TimeTableCellViewModel]()
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeTableTableView.delegate = self
        timeTableTableView.dataSource = self
        //        timeTableTableView.separatorStyle = .none
        
        let networkAdapter = NetworkManager()
        movies = networkAdapter.getMovies()
        for movie in movies {
            let movieViewModel = TimeTableCellViewModel(movie: movie)
            movieViewModelList.append(movieViewModel)
        }
        
        timeTableTableView.register(UINib(nibName: "TimeTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        resizeTableViewRows()
        
        timeTableTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - TableView Implementation methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModelList.count
    }
    // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeTableTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! TimeTableViewCell
        let movie = movieViewModelList[indexPath.row]
        
        cell.setUp(viewModel: movie)
        return cell
    }
    
    // Resize row
    func resizeTableViewRows () {
        timeTableTableView.rowHeight = 300
    }
    
    //UITableViewCell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var selectedItem = movieViewModelList[indexPath.row]
        performSegue(withIdentifier: "goToMovieDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMovieDetails" {
            let destinationVC = segue.destination as! MovieDetailsViewController
            if let indexPath = timeTableTableView.indexPathForSelectedRow {
                destinationVC.movie = movieViewModelList[indexPath.row]
            }
        }
    }
    
}