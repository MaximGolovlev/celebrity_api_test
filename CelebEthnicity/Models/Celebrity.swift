//
//  Celebrity.swift
//  CelebEthnicity
//
//  Created by User on 12.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import ObjectMapper

class Celebrity: Mappable {

    var name: String?
    var picture: String?
    var birthName: String?
    var birthPlace: String?
    var dateOfBith: String?
    var deathPlace: String?
    var dateOfDeath: String?
    var ethnicity: [Ethnicity]?
    var description: String?
    var sources: [String]?
    var similar: [String]?
    var tags: [String]?
    var comments: [Comment]?
    var lastUpdate: Date?
    
    init(name: String?, picture: String? = nil, birthName: String? = nil, birthPlace: String? = nil, dateOfBith: String? = nil, ethnicity: [Ethnicity]? = nil, tags: [String]? = nil, similar: [String]? = nil, description: String? = nil, deathPlace: String? = nil, dateOfDeath: String? = nil) {
        self.name = name
        self.picture = picture
        self.birthName = birthName
        self.birthPlace = birthPlace
        self.dateOfBith = dateOfBith
        self.ethnicity = ethnicity
        self.tags = tags
        self.similar = similar
        self.description = description
        self.deathPlace = deathPlace
        self.dateOfDeath = dateOfDeath
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        picture     <- map["picture"]
        birthName   <- map["birthName"]
        birthPlace  <- map["birthPlace"]
        dateOfBith  <- map["dateOfBith"]
        ethnicity   <- map["ethnicity"]
        description <- map["description"]
        sources     <- map["sources"]
        similar     <- map["similar"]
        tags        <- map["tags"]
        comments    <- map["comments"]
        lastUpdate  <- map["lastUpdate"]
    }
}

class Ethnicity: Mappable {
    
    var name: String?
    var percent: String?
    
    init(name: String?, percent: String?) {
        self.name = name
        self.percent = percent
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name    <- map["name"]
        percent <- map["percent"]
    }
    
}

class Comment: Mappable {
    
    var text: String?
    var date: Date?
    var user: User?
    var replies: [Comment]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        text    <- map["text"]
        date    <- map["date"]
        user    <- map["user"]
        replies <- map["replies"]
    }
    
}

class User: Mappable {
    
    var name: String?
    var avatar: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name    <- map["name"]
        avatar  <- map["avatar"]
    }
    
}
