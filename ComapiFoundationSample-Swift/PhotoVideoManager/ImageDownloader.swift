//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

class ImageDownloader: NSObject {

    fileprivate let operationQueue = OperationQueue()
    fileprivate var imageSession: URLSession!
    
    deinit {
        imageSession.invalidateAndCancel()
        operationQueue.cancelAllOperations()
    }

    override init() {
        operationQueue.maxConcurrentOperationCount = 3

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy

        super.init()
        
        imageSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: operationQueue)
    }

    func download(_ url: URL, successCompletion: ((UIImage?) -> Void)?, failureCompletion: ((Error?) -> Void)? = nil) {
        let task = imageSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data, let image = UIImage(data: data), error == nil {
                DispatchQueue.main.async {
                    successCompletion?(image)
                }

                return
            }

            DispatchQueue.main.async {
                failureCompletion?(error)
            }
        }) 

        task.resume()
    }

    func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
}

//extension ImageDownloader: URLSessionDelegate {
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//            if challenge.protectionSpace.host == ServerParameters.host {
//                if let trust = challenge.protectionSpace.serverTrust {
//                    let credential = URLCredential.init(trust: trust)
//                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
//                } else {
//                    print("serverTrust empty")
//                }
//            }
//        }
//    }
//}
