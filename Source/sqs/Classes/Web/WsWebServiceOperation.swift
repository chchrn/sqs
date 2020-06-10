//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises

internal class WsWebServiceOperation: Operation {
    private let urlSession: URLSession
    private let request: WsRequestI
    private let priority: Float
    private let promise: Promise<WsWebResponse>
    private let progressBlock: WsWebService.ProgressBlock?
    private var isProgressSubscribed: Bool = false
    private var task: URLSessionDataTask?

    init(urlSession: URLSession,
         request: WsRequestI,
         priority: Float,
         promise: Promise<WsWebResponse>,
         progressBlock: WsWebService.ProgressBlock?) {
        self.urlSession = urlSession
        self.request = request
        self.priority = priority
        self.promise = promise
        self.progressBlock = progressBlock
    }

    deinit {
        self.unsubscribeFromProgress()
    }

    override var isAsynchronous: Bool {
        return true
    }

    var p_isFinished: Bool = false
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            p_isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
        get {
            return p_isFinished
        }
    }

    var p_isExecuting: Bool = false
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            p_isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
        get {
            return p_isExecuting
        }
    }

    override func start() {
        self.isExecuting = true
        let urlRequest = self.request.urlRequest()
        let task = self.urlSession.dataTask(with: urlRequest
        ) { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) -> Void in
            guard let strongSelf = self else {return}
            if error != nil {
                strongSelf.handle(error: error!)
            } else {
                assert(urlResponse != nil)
                let forcedData = data ?? Data()
                strongSelf.handle(response: WsWebResponse(data: forcedData,
                                                          urlResponse: urlResponse!))
            }
        }
        task.priority = self.priority
        self.task = task
        self.subscribeToProgress()
        task.resume()
    }

    override var queuePriority: QueuePriority {
        get {
            if self.priority <= 0.1 {
                return .veryLow
            } else if self.priority <= 0.3 {
                return .low
            } else if self.priority <= 0.5 {
                return .normal
            } else if self.priority <= 0.7 {
                return .high
            } else {
                return .veryHigh
            }
        }
        set {
            super.queuePriority = newValue
        }
    }

    private func handle(response: WsWebResponse) {
        self.promise.fulfill(response)
        self.endExecution()
    }

    private func handle(error: Error) {
        self.promise.reject(error)
        self.endExecution()
    }

    private func endExecution() {
        self.unsubscribeFromProgress()
        self.isExecuting = false
        self.isFinished = true
    }

    private func subscribeToProgress() {
        if self.isProgressSubscribed == false && self.task != nil {
            self.isProgressSubscribed = true
            if #available(iOS 11, *) {
                self.task?.progress.addObserver(self,
                                                forKeyPath: "fractionCompleted",
                                                options: [.new],
                                                context: nil)
            }
        }
    }

    private func unsubscribeFromProgress() {
        if self.isProgressSubscribed == true && self.task != nil {
            self.isProgressSubscribed = false
            if #available(iOS 11, *) {
                self.task?.progress.removeObserver(self,
                                                   forKeyPath: "fractionCompleted",
                                                   context: nil)
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted" {
            let progress: Progress = object as! Progress
            self.progressBlock?(Float(progress.fractionCompleted), Int(progress.totalUnitCount))
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
