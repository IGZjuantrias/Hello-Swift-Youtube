//
//  YoutubeApiClient.swift
//  Hello Swift
//
//  Created by Juan on 11/07/14.
//  Copyright (c) 2014 IGZ. All rights reserved.
//

import Foundation

// Singleton in Swift:  http://stackoverflow.com/questions/24024549/dispatch-once-singleton-model-in-swift

let sharedYoutubeApiClient = YoutubeApiClient()

// DO not store results-related information in this class as page tokens. The same object could be shared in different parts of the app (currently is a Singleton) and should not maintain state

class YoutubeApiClient {
    class var sharedClient:YoutubeApiClient {
        return sharedYoutubeApiClient
    }
    
    private let YOUTUBE_API_URL = "https://www.googleapis.com/youtube/v3/"
    private let YOUTUBE_API_SEARCH = "search"
    private let YOUTUBE_API_KEY = "AIzaSyAFUUlXucib_q6uw7tw_3G-s9FzHy39c8U"
    
    private var requestManager: AFHTTPRequestOperationManager
    
    init() {
        requestManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: YOUTUBE_API_URL))
    }
    
    // Como definimos el callback cuando se han guardado los datos en el Realm? Come gestionamos la paginacion con el Realm?
    
    func search(query: String, pageToken: String?, resultsPerPage: UInt, onSuccess: (searchListJSONModel: YUSearchListJSONModel) -> Void, onError: (NSError) -> Void) {
        
        var params = ["part": "id,snippet", "q": query, "type": "video", "maxResults": String(resultsPerPage), "key": YOUTUBE_API_KEY]
        
        if (pageToken != nil) {
            params["pageToken"] = pageToken
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.setNetworkActivityIndicatorVisible(true)
        
        requestManager.GET(YOUTUBE_API_SEARCH, parameters: params, clazz:YUSearchListJSONModel.classForCoder()
        , success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) in
            let searchListJSONModel = response as YUSearchListJSONModel
            //println("searchListJSONModel: \(searchListJSONModel)")
            
            appDelegate.setNetworkActivityIndicatorVisible(false)
            
            onSuccess(searchListJSONModel: searchListJSONModel)
        }
        , failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
            println("Error received \(error)")
            println("Operation \(operation.request)")
            appDelegate.setNetworkActivityIndicatorVisible(false)
            onError(error)
        })
    }
    
}
