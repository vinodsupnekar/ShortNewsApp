//
//  HTTPClient.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 18/10/24.
//

public protocol HTTPClient {
    
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
