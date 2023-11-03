//
//  KfImageSize.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/02.
//

import Kingfisher

extension ImageDownloader {
    static func downloadImageSize(with url: URL, completion: @escaping (CGSize?) -> Void) {
        ImageDownloader.default.downloadImage(with: url) { result in
            switch result {
            case .success(let value):
                let imageSize = value.image.size
                completion(imageSize)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
