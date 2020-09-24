//
//  Created by Menno Lovink on 03/05/16.
//  Copyright © 2016 M2mobi. All rights reserved.
//

import UIKit

public protocol BaseFontStylingRule: ItemStyling {

    var baseFont: UIFont? { get }
}

extension ItemStyling {

    func neededBaseFont() -> UIFont? {
        for styling in stylingWithPrecedingStyling() {
            if let styling = styling as? BaseFontStylingRule, styling.baseFont != nil {
                return styling.baseFont
            }
        }
        return nil
    }

    func neededFont() -> UIFont? {

        var font: UIFont? = neededBaseFont()

        if shouldFontBeBold() && shouldFontBeItalic() {
            font = font?.makeItalicBold()
        } else if shouldFontBeBold() {
            font = font?.makeBold()
        } else if shouldFontBeItalic() {
            font = font?.makeItalic()
        }

        if let textSize = neededTextSize() {
            font = font?.changeSize(textSize)
        }

        return font
    }
}

private extension UIFont {

    func makeBold() -> UIFont? {
        if let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) {
            if #available(iOS 11.0, *) {
                return UIFontMetrics.default.scaledFont(for: UIFont(descriptor: descriptor, size: pointSize))
            } else {
                return UIFont(descriptor: descriptor, size: pointSize)
            }

        }

        return nil
    }

    func makeItalic() -> UIFont? {
        if let descriptor = fontDescriptor.withSymbolicTraits(.traitItalic) {
            if #available(iOS 11.0, *) {
                return UIFontMetrics.default.scaledFont(for: UIFont(descriptor: descriptor, size: pointSize))
            } else {
                return UIFont(descriptor: descriptor, size: pointSize)
            }

        }

        return nil
    }

    func makeItalicBold() -> UIFont? {
        if let descriptor = fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold]) {
            if #available(iOS 11.0, *) {
                return UIFontMetrics.default.scaledFont(for: UIFont(descriptor: descriptor, size: pointSize))
            } else {
                return UIFont(descriptor: descriptor, size: pointSize)
            }
        }

        return nil
    }

    func changeSize(_ size: CGFloat) -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(
                for: UIFont(descriptor: self.fontDescriptor.withSize(size), size: size))
        } else {
            return UIFont(descriptor: self.fontDescriptor.withSize(size), size: size)
        }
    }
}
