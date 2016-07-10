//
//  Model.swift
//  Udacity_TVOS
//
//  Created by inailuy on 7/8/16.
//
//

import Foundation

enum Key: String {
    case etag = "etag"
    case items = "items"
    case kind = "kind"
    case nextPageToken = "nextPageToken"
    case pageInfo = "pageInfo"
    
    case id = "id"
    case snippet = "snippet"
    
    case channelId = "channelId"
    case channelTitle = "channelTitle"
    case description = "description"
    case localized = "localized"
    case publishedAt = "publishedAt"
    case thumbnails = "thumbnails"
    case title = "title"
    
    case defaults = "default"
    case high = "high"
    case medium = "medium"
    
    case height = "height"
    case url = "url"
    case width = "width"
    
    case resultsPerPage = "resultsPerPage"
    case totalResults = "totalResults"
}

struct Playlist {
    
    var etag :String
    var items :[Item]
    var kind :String
    var nextPageToken :String
    var pageInfo :PageInfo
    
    init(dictionary :NSDictionary){
        etag = dictionary[Key.etag.rawValue] as! String
        kind = dictionary[Key.etag.rawValue] as! String
        nextPageToken = dictionary[Key.nextPageToken.rawValue] as! String
        pageInfo = PageInfo(dictionary: dictionary[Key.pageInfo.rawValue] as! NSDictionary)
        
        var tmpArray = [Item]()
        for dictionaryObject in dictionary[Key.items.rawValue] as! [NSDictionary] {
            let item = Item(dictionary: dictionaryObject)
            tmpArray.append(item)
        }
        items = tmpArray
    }
}

struct Item {
    
    var etag :String
    var id :String
    var kind :String
    var snippet :Snippet
    
    init(dictionary: NSDictionary) {
        etag = dictionary[Key.etag.rawValue] as! String
        id = dictionary[Key.id.rawValue] as! String
        kind = dictionary[Key.kind.rawValue] as! String
        snippet = Snippet(dictioanry: dictionary[Key.snippet.rawValue] as! NSDictionary)
    }
}

struct Snippet {
    var channelId :String
    var channelTitle :String
    var description :String
    var localized :Localized
    var publishedAt :String
    var thumbnails :Thumbnails
    var title :String
    
    init(dictioanry: NSDictionary) {
        channelId = dictioanry[Key.channelId.rawValue] as! String
        channelTitle = dictioanry[Key.channelTitle.rawValue] as! String
        description = dictioanry[Key.description.rawValue] as! String
        localized = Localized(dictionary: dictioanry[Key.localized.rawValue] as! NSDictionary)
        publishedAt = dictioanry[Key.publishedAt.rawValue] as! String
        thumbnails = Thumbnails(dictioanry: dictioanry[Key.thumbnails.rawValue] as! NSDictionary)
        title = dictioanry[Key.title.rawValue] as! String
    }
}

struct Localized {
    var description :String
    var title :String
    
    init(dictionary: NSDictionary) {
        description = dictionary[Key.description.rawValue] as! String
        title = dictionary[Key.title.rawValue] as! String
    }
}

struct Thumbnails {
    var defaults :ThumbnailObject
    var high :ThumbnailObject
    var medium :ThumbnailObject
    
    init(dictioanry:NSDictionary) {
        defaults = ThumbnailObject(dictionary: dictioanry[Key.defaults.rawValue] as! NSDictionary)
        high = ThumbnailObject(dictionary: dictioanry[Key.high.rawValue] as! NSDictionary)
        medium = ThumbnailObject(dictionary: dictioanry[Key.medium.rawValue] as! NSDictionary)
    }
}

struct ThumbnailObject {
    var height :Int
    var url :String
    var width :Int
    
    init(dictionary: NSDictionary){
        height = dictionary[Key.height.rawValue] as! Int
        url = dictionary[Key.url.rawValue] as! String
        width = dictionary[Key.width.rawValue] as! Int
    }
}

struct PageInfo {
    var resultsPerPage :Int
    var totalResults :Int
    
    init(dictionary: NSDictionary){
        resultsPerPage = dictionary[Key.resultsPerPage.rawValue] as! Int
        totalResults = dictionary[Key.totalResults.rawValue] as! Int
    }
}