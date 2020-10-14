//
//  Created by Jim van Zummeren on 03/05/16.
//  Copyright © 2016 M2mobi. All rights reserved.
//

import Foundation
import Kingfisher

open class ImageMarkDownItem: MarkDownItem {

    public let file: String
    public let altText: String
    public private(set) var remoteImage: KFCrossPlatformImage?

    public init(lines: [String], file: String, altText: String) {
        self.file = file
        self.altText = altText
        super.init(lines: lines, content: altText)
        fetchRemoteImage()
    }

    required public init(lines: [String], content: String) {
        fatalError("init(lines:content:) has not been implemented")
    }

    private func fetchRemoteImage() {
        guard let url = URL(string: file) else { return }

        // This will retrieve the image from the cache or download it (async) and store it in the cache.
        // The completion handler will be invoked on the main thread.
        KingfisherManager.shared.retrieveImage(
            with: url.addHTTPSIfSchemeIsMissing(),
            options: [.processor(MarkDownImageProcessor())]
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.remoteImage = imageResult.image
                self.onAsyncComplete?()
            case .failure(let error):
                print("Error retrieving remote image: \(error.localizedDescription)")
            }
        }
    }
}
