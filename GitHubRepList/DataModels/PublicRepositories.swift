//
//  PublicRepositories.swift
//  GitHubRepList
//
//  Created by Mihael Matyatsko on 07.07.2021.
//
import CoreData
import Foundation

struct JSONFile: Codable {
    let total_count: UInt64
    let incomplete_results: Bool
    let items: [PublicRepositories]
    
    enum CodingKeys: String, CodingKey{
        case total_count
        case incomplete_results
        case items
    }
}

struct PublicRepositories: Codable {
    var id: UInt64
    var full_name: String
    var description: String
    var watchers: UInt64
    var html_url: String
    var owner: PRAvatar
    
    enum CodingKeys: String, CodingKey{
        case id
        case full_name
        case description
        case watchers
        case html_url
        case owner
    }
}

struct PRAvatar: Codable{
    var avatar_url: String
    
    enum CodingKeys: String, CodingKey{
        case avatar_url
    }
}
