//
//  NetworkManager.swift
//  SetelAssignment
//
//  Created by Anh Le on 18/02/2022.
//

import Foundation
import NetworkExtension

protocol NetworkManagerType {
    func fetchSSDI() async -> String?
    func fetchSSDI(completion: @escaping ((String?) -> ()))
}

class NetworkManger: NetworkManagerType {
    
    static let shared = NetworkManger()
    
    private init() {}
    
    func fetchSSDI() async -> String? {
        let network = await NEHotspotNetwork.fetchCurrent()
        return network?.ssid
    }
    
    func fetchSSDI(completion: @escaping ((String?) -> ())) {
        NEHotspotNetwork.fetchCurrent { network in
            completion(network?.ssid)
        }
    }
}
