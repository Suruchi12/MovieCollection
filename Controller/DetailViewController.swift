//
//  DetailViewController.swift
//  JSON
//
//  Created by Suruchi Singh on 3/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var link: String = ""
    var movie : MovieInfo?{
        
        didSet{
            
            navigationItem.title = self.movie?.title
       
            let id = movie?.id
            print("DVC didSet Movie ID is : \(id!)")
            link = "https://api.themoviedb.org/3/movie/\(id!)?api_key=9833efb4636d8626663b18c31ccdc1a9"
        }
    }
    
    let header:DetailHeader = {
        
        let header = DetailHeader()
        print("Detail View Controller Header movie title : \(header.releaseDate.text!)")
        return header
    }()
    
    let poster:DetailPoster = {
        
        let poster = DetailPoster()
        print("poster is : \(poster)")
        return poster
    }()
    
    
     let overview:DetailDescription = {
     
       let overview = DetailDescription()
        print("overview :  \(overview)")
       return overview
     }()
 
    func setupViews(){
        
        //view.backgroundColor = UIColor.cyan
        //let view = UIView()
        //view.backgroundColor = #colorLiteral(red: 0.6141117286, green: 0.9503401797, blue: 0.9686274529, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 1, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        header.movie = movie
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
 
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //header.backgroundColor = .red
        header.setupViews()
        
        poster.movie = movie
        view.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        poster.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        poster.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        poster.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        poster.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        //poster.bottomAnchor.constraint(equalTo: overview.topAnchor).isActive = true
        poster.setupViews()
        poster.backgroundColor = .clear
        //poster.backgroundColor = .green
        
        overview.movie = movie
        view.addSubview(overview)
        overview.translatesAutoresizingMaskIntoConstraints = false
        
        overview.topAnchor.constraint(equalTo: poster.bottomAnchor).isActive = true
        overview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       // overview.backgroundColor = UIColor.gray
        
        overview.setupViews()
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    
    }
    
}

//MARK:- Download Image from a URL
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func downloadImageUsingCache(_ urlLink: String){
        self.image = nil
        if urlLink.isEmpty {
            return
        }
        if let cachedImage = imageCache.object(forKey: urlLink as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlLink)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error{
                print(error)
                return
            }
            
            DispatchQueue.main.async() {
                if let newImage = UIImage(data: data!){
                    imageCache.setObject(newImage, forKey: urlLink as NSString)
                    self.image = newImage
                }
            }
            
            }.resume()
    }
}


//MARK:- Constraints
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}

