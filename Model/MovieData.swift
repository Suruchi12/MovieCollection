//
//  MovieData.swift
//  JSON
//
//  Created by Suruchi Singh on 3/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation

struct MovieInfo: Decodable{
    
    let id : Int?
    let posterPath:String?
    let backdrop: String?
    let title: String?
    let releaseDate: String?
    let rating:Double?
    let overview:String?
    let originalTitle:String?
    //var genres : [GenreInfo]
    private enum CodingKeys: String, CodingKey{
        
        case id, posterPath = "poster_path", backdrop = "backdrop_path", title, releaseDate = "release_date", rating = "vote_average", overview, originalTitle = "original_title"//, genres
    }
}

struct GenreInfo: Decodable {
    
    let id : Int?
    let name : String?
}

struct MovieResults: Decodable {
    
    let page : Int?
    let numResults:Int?
    let numPages:Int?
    
    var movies : [MovieInfo]
    
    private enum CodingKeys : String, CodingKey{
        case page, numResults = "total_results", numPages = "total_pages", movies = "results"
    }
}



