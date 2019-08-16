//
//  WebServices.swift
//  WaitingForConnectivityDemo
//
//  Created by Yuriy Zabroda on 8/16/19.
//  Copyright © 2019 Yuriy Zabroda. All rights reserved.
//

import Foundation


extension Notification.Name {
    /**
     Posted when a network request is successful.
     */
    public static let networkWakeUpNotification = Notification.Name("com.yz.networkWakeUpNotification")

    /**
     Posted when any resumed `URLSessionTask` is waiting for connectivity.
     */
    public static let waitingForConnectivityNotification = Notification.Name("com.yz.waitingForConnectivityNotification")
}



class WebServices: NSObject {

    enum ServerSideError {
        case noData
        case httpServerError
    }


    static let shared = WebServices()


    func callingApple(completionHandler: @escaping (_ text: String?, _ error: Error?) -> Void) {
        urlSession.dataTask(with: URL(string: "https://www.apple.com")!) { data, response, error in
            if let error = error {
                return completionHandler(nil, error)
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completionHandler(nil, ServerSideError.httpServerError)
            }

            guard let data = data else {
                return completionHandler(nil, ServerSideError.noData)
            }

            if let text = String(data: data, encoding: .utf8) {
                return completionHandler(text, nil)
            }
        }.resume()
    }

    private override init() {
        super.init()
    }


    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true

        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
}



extension WebServices: URLSessionTaskDelegate {

    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        NotificationCenter.default.post(name: .waitingForConnectivityNotification, object: nil)
    }
}




extension WebServices.ServerSideError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data"
        case .httpServerError:
            return "HTTP server error"
        }
    }
}
