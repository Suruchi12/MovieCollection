//
//  TopRatedViewController.swift
//  Suruchi_Assignment3
//
//  Created by Suruchi Singh on 3/19/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

class TopRatedTableViewController: UITableViewController{
    
    var results: MovieResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 195
        tableView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        
        navigationItem.title =  "Top Rated Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        
        tableView.sectionHeaderHeight = 30
        
        downloadJSON {
            print("Successfull")
            self.tableView.reloadData()
        }
        
        
        
    }
    
    //MARK:- JSON Parsing
    func downloadJSON(completed: @escaping () -> ()){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=appikey")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil{
                guard let jsondata = data else {return}
                
                do{
                    self.results = try JSONDecoder().decode(MovieResults.self, from: jsondata)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch{
                    
                    print("JSON Error")
                }
            }
            }.resume()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK:- Get the count of rows in the Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let number = results?.movies.count{
            return number
        }
        else {return 0}
    }
    
    //MARK:- Height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189
    }
    
    //MARK:- Customizing a Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let posterpath = results?.movies[indexPath.row].posterPath
        let link = "https://image.tmdb.org/t/p/w185/\(posterpath!)"
        //let url = URL(string: link)
        let name = results?.movies[indexPath.row].title
        let rating = results?.movies[indexPath.row].rating
        let finalRating = String(format: "%.0f",rating!)
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellid")
        
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        
        //cell.imageView?.downloadedFrom(url: url!)
        
        cell.imageView?.downloadImageUsingCache(link)
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        cell.textLabel?.font = UIFont(name: "HoeflerText-BlackItalic", size: 28)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0;
        
        cell.textLabel?.text = name
        
        cell.detailTextLabel?.text = "Rating: "
        cell.detailTextLabel?.text?.append("\(finalRating)/10")
        cell.detailTextLabel?.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        
        if indexPath.row % 2 == 0 {
            //cell.contentView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            //cell.contentView.backgroundColor = hexStringToUIColor(hex: "#D9364C")
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#EE6868")
            cell.textLabel?.textColor = #colorLiteral(red: 0.9567734772, green: 0.9567734772, blue: 0.9567734772, alpha: 1)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        else{
            //cell.contentView.backgroundColor = #colorLiteral(red: 0.6090981096, green: 0.8779214232, blue: 0.9200183371, alpha: 1)
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#FF9B9B" )
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        
        return cell
    }
    
    
    //MARK:- Delete a cell from Table View
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            results?.movies.remove(at: indexPath.row)
            print("Deleting movie at \(indexPath.row)")
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
    }
    
    //MARK:- Go to Details View Controller
    func showMovie(movie : MovieInfo){
        
        let detailController = DetailViewController()
        detailController.movie = movie
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    //MARK:- If Row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let movie = results?.movies[indexPath.row]{
            self.showMovie(movie:movie)
            print("\(movie.title!) selected")
            
        }
    }
    
    //MARK:- Hex Colours
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.blue
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

