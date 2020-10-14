//
//  MarkDownImageProcessor.swift
//  markymark
//
//  Created by Stefan Compton on 10/14/20.
//

import Kingfisher
import CoreGraphics
import UIKit

struct MarkDownImageProcessor: ImageProcessor {

    // `identifier` should be the same for processors with same properties/functionality
    // It will be used when storing and retrieving the image to/from cache.
    let identifier = "com.m2mobi.marky-mark.MarkDownImageProcessor"

    // Convert input data/image to target image and return it.
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
        case .data(let data):
            // If we have a known/supported image format then defer to standard data processing
            guard data.kf.imageFormat == .unknown else {
                return KingfisherWrapper.image(
                    data: data,
                    options: ImageCreatingOptions(
                        scale: options.scaleFactor,
                        duration: 0.0,
                        preloadAll: options.preloadAllAnimationData,
                        onlyFirstFrame: options.onlyLoadFirstFrame)
                )
            }

            // If the image format is unknown then try PDF
            let pdfData = data as CFData
            guard
                let provider = CGDataProvider(data: pdfData),
                let pdfDoc = CGPDFDocument(provider),
                let pdfPage = pdfDoc.page(at: 1)
                else {
                    return nil
            }

            var pageRect = pdfPage.getBoxRect(.mediaBox)
            pageRect.size = CGSize(width: pageRect.size.width, height: pageRect.size.height)
            UIGraphicsBeginImageContextWithOptions(pageRect.size, false, UIScreen.main.scale)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1, y: -1)
            context.concatenate(
                pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(pdfPage)
            context.restoreGState()
            let pdfImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return pdfImage
        }
    }
}

