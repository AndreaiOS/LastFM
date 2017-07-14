//
//  NetworkClient.swift
//  LastFM
//
//  Created by Andrea Murru on 14/07/2017.
//  Copyright © 2017 Andrea Murru. All rights reserved.
//

import Foundation

/**
 NetworkClient is a class that is responsible for dispatching Requests,
 optionally parsing json responses,
 and executing Components at different times of request Life cycle.
 
 Example usage:
 
 let client = NetworkClient()
 
 // GetSongByTitle is a Request
 let request = GetSongByTitle(title: "Belive")
 
 
 client.requestObject(
 // User has to be a NetworkJSONDecodable class or struct
 ofType: Song.self,
 request: request,
 onSuccess: { (song: Song) in
 // Please note that song is already parsed for you.
 // You are free! Do whatever you want with your user!
 },
 onError: { (error: Error) in
 // Oops! Something went wrong... you may want to handle this error yourself.
 }
 )
 
 */
open class NetworkClient {
    
    // MARK: - Attributes -
    
    let engine: NetworkEngine
    
    /**
     NetworkClient has its own plugin collection that act
     after sending requests and after receiving responses
     */
    public var plugins = [NetworkPlugin]()
    
    /**
     NetworkClient has its own response processors collection that act
     after receiving a response and before firing responses handler plugins.
     */
    public var responseProcessors = [NetworkResponseProcessor]()
    
    /**
     NetworkClient has its own response validators collection that act
     after receiving a response
     */
    public var responseValidators = [NetworkResponseValidator]()
    
    // MARK: - Init -
    
    /**
     By default, NetworkClient relies on URLSession.shared,
     but you can inject any custom URLSession.
     
     @param urlSession custom URLSession that is used to perform Konex requests.
     */
    public init(engine: NetworkEngine = URLSessionEngine()) {
        self.engine = engine
    }
    
    // MARK: - Requests dispatching -
    
    /**
     This is the main method in NetworkClient
     
     Basically, using this method you can dispatch a Request via NetworkEngine and receive a data
     response, or an error, that are handled by closures that you send to this method.
     
     request method also accept a collection of plugins, response processors and response validators.
     
     - parameter request: a Request, that is dispatched by NetworkEngine.
     
     - parameter plugins: an array of Plugin, that are executed after sending a request and after receiving a response.
     
     - parameter responseProcessors: an array of NetworkResponseProcessor
     
     - parameter responseValidators: an array of NetworkResponseValidator
     
     - parameter onSuccess: a closure that is executed with the received JSON, represented as Any.
     
     - parameter onError: a closure that is executed if anything went wrong. The error sent to this closure is of NetworkError type, or any Error that can return after executing a NetworkResponseValidator.
     
     - returns: a URLSessionDataTask, that you can use to cancel the request at any time.
     
     */
    @discardableResult
    open func request(request: Request, plugins localPlugins: [NetworkPlugin] = [], responseProcessors localResponseProcessors: [NetworkResponseProcessor] = [], responseValidators localResponseValidators: [NetworkResponseValidator] = [], onSuccess: @escaping (Any) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        let plugins = localPlugins + request.requestPlugins + self.plugins
        let responseProcessors = localResponseProcessors + request.requestResponseProcessors + self.responseProcessors
        let responseValidators = localResponseValidators + request.requestResponseValidators + self.responseValidators
        
        let dataTask = engine.dispatch(
            request: request,
            onSuccess: { json in
                plugins.forEach { $0.didReceiveResponse(json, from: request) }
                
                for validator in responseValidators {
                    do {
                        try validator.validate(response: json)
                    } catch let error {
                        onError(error)
                        return
                    }
                }
                
                var processedResponse = json
                
                for processor in responseProcessors {
                    processedResponse = processor.process(response: processedResponse)
                }
                
                DispatchQueue.main.async {
                    onSuccess(processedResponse)
                }
        },
            onError: { error in
                DispatchQueue.main.async {
                    onError(error)
                }
        }
        )
        
        plugins.forEach { $0.didSendRequest(request) }
        
        return dataTask
    }
    
    /**
     Dispatches the Request using the NetworkEngine and then parses the response using NetworkJSONDecodable protocol to get an object of the given type.
     
     - parameter ofType: a NetworkJSONDecodable type to transform the response JSON.
     
     - parameter request: a Request, that is then dispatched by NetworkEngine.
     
     - parameter plugins: an array of NetworkPlugin, that are executed after sending a request and after receiving a response.
     
     - parameter responseProcessors: an array of NetworkResponseProcessor
     
     - parameter responseValidators: an array of NetworkResponseValidator
     
     - parameter onSuccess: a closure that is executed with the received JSON, represented as Any.
     
     - parameter onError: a closure that is executed if anything went wrong. The error sent to this closure is of NetworkError type, or any Error that can return after executing a NetworkResponseValidator.
     
     - returns: a URLSessionDataTask, that you can use to cancel the request at any time.
     */
    @discardableResult
    open func requestObject<T:NetworkJSONDecodable>(ofType type: T.Type, request: Request, plugins localPlugins: [NetworkPlugin] = [], responseProcessors localResponseProcessors: [NetworkResponseProcessor] = [], responseValidators localResponseValidators: [NetworkResponseValidator] = [], onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        return self.request(request: request,
                            plugins: localPlugins,
                            responseProcessors: localResponseProcessors,
                            responseValidators: localResponseValidators,
                            onSuccess: { response in
                                guard let json = response as? [String: Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                guard let parsedObject = T.instantiate(withJSON: json) else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                onSuccess(parsedObject)
        },
                            onError: { error in
                                onError(error)
        }
        )
    }
    
    /**
     Dispatches the Request using the NetworkEngine and then parses the response using NetworkJSONDecodable protocol to get an array of the given type.
     
     - parameter of: a NetworkJSONDecodable type to transform the response JSON.
     
     - parameter request: a Request, that is dispatched via NetworkEngine.
     
     - parameter plugins: an array of NetworkPlugin, that are executed after sending a request and after receiving a response.
     
     - parameter responseProcessors: an array of NetworkResponseProcessor
     
     - parameter responseValidators: an array of NetworkResponseValidator
     
     - parameter onSuccess: a closure that is executed with the received JSON, represented as Any.
     
     - parameter onError: a closure that is executed if anything went wrong. The error sent to this closure is of NetworkError type, or any Error that can return after executing a NetworkResponseValidator.
     
     - returns: a URLSessionDataTask, that you can use to cancel the request at any time.
     */
    @discardableResult
    open func requestSongArray<T: NetworkJSONDecodable>(of type: T.Type, request: Request, plugins localPlugins: [NetworkPlugin] = [], responseProcessors localResponseProcessors: [NetworkResponseProcessor] = [], responseValidators localResponseValidators: [NetworkResponseValidator] = [], onSuccess: @escaping ([T]) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        return self.request(request: request,
                            plugins: localPlugins,
                            responseProcessors: localResponseProcessors,
                            responseValidators: localResponseValidators,
                            onSuccess: { response in
                                guard let json = response as? [String: Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }

                                guard let results = json["results"] as? [String:Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let trackMatches = results["trackmatches"] as? [String:Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let list = trackMatches["track"] as? [[String:Any]] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                var array = [T]()
                                
                                for singleElement in list {
                                    guard let parsedObject = T.instantiate(withJSON: singleElement) else {
                                        onError(NetworkError.invalidParsing)
                                        return
                                    }
                                    array.append(parsedObject)
                                }
                                
                                onSuccess(array)
        },
                            onError: { error in
                                onError(error)
        }
        )
    }
    
    @discardableResult
    open func requestArtistArray<T: NetworkJSONDecodable>(of type: T.Type, request: Request, plugins localPlugins: [NetworkPlugin] = [], responseProcessors localResponseProcessors: [NetworkResponseProcessor] = [], responseValidators localResponseValidators: [NetworkResponseValidator] = [], onSuccess: @escaping ([T]) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        return self.request(request: request,
                            plugins: localPlugins,
                            responseProcessors: localResponseProcessors,
                            responseValidators: localResponseValidators,
                            onSuccess: { response in
                                guard let json = response as? [String: Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let results = json["results"] as? [String:Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let artistMatches = results["artistmatches"] as? [String:Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let artist = artistMatches["artist"] as? [[String:Any]] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                var array = [T]()
                                
                                for singleElement in artist {
                                    guard let parsedObject = T.instantiate(withJSON: singleElement) else {
                                        onError(NetworkError.invalidParsing)
                                        return
                                    }
                                    array.append(parsedObject)
                                }
                                
                                onSuccess(array)
        },
                            onError: { error in
                                onError(error)
        }
        )
    }
    
    @discardableResult
    open func requestAlbumArray<T: NetworkJSONDecodable>(of type: T.Type, request: Request, plugins localPlugins: [NetworkPlugin] = [], responseProcessors localResponseProcessors: [NetworkResponseProcessor] = [], responseValidators localResponseValidators: [NetworkResponseValidator] = [], onSuccess: @escaping ([T]) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        return self.request(request: request,
                            plugins: localPlugins,
                            responseProcessors: localResponseProcessors,
                            responseValidators: localResponseValidators,
                            onSuccess: { response in
                                guard let json = response as? [String: Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let results = json["results"] as? [String:Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let albumMatches = results["albummatches"] as? [String:Any] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                guard let list = albumMatches["album"] as? [[String:Any]] else {
                                    onError(NetworkError.invalidParsing)
                                    return
                                }
                                
                                var array = [T]()
                                
                                for singleElement in list {
                                    guard let parsedObject = T.instantiate(withJSON: singleElement) else {
                                        onError(NetworkError.invalidParsing)
                                        return
                                    }
                                    array.append(parsedObject)
                                }
                                
                                onSuccess(array)
        },
                            onError: { error in
                                onError(error)
        }
        )
    }
}
