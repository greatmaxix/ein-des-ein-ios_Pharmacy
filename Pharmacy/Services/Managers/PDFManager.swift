//
//  PDFManager.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit
import WebKit

typealias PDFDownloadHandler = (Result<URL, Error>) -> Void

enum DownloadError: Error {
    case failure
}

class PDFManager: NSObject {

    static let shared = PDFManager()

    private var vc: UIViewController!

    func download(by url: URL, completion: @escaping PDFDownloadHandler) {

        guard var request = try? URLRequest(url: url, method: .get) else { return }

        request.setValue("Bearer \(KeychainManager.shared.getToken() ?? "")", forHTTPHeaderField: "Authorization")

        let downloadTask = URLSession.shared.downloadTask(with: request) { (location, response, error) in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let location = location else {
                DispatchQueue.main.async { completion(.failure(DownloadError.failure)) }
                return
            }

            let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.removeItem(at: destinationURL)

            // copy from temp to Document
            do {
                try FileManager.default.copyItem(at: location, to: destinationURL)
                DispatchQueue.main.async { completion(Result.success(destinationURL)) }
            } catch let error {
                DispatchQueue.main.async { completion(Result.failure(error)) }
            }
        }

        downloadTask.resume()
    }
}
