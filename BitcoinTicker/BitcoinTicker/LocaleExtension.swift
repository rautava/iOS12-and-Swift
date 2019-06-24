//
//  LocaleExtension.swift
//  BitcoinTicker
//
//  Created by Tommi Rautava on 24/06/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import Foundation

/**
 Source: https://stackoverflow.com/questions/48136456/locale-current-reporting-wrong-language-on-device
 */
extension Locale {
    static func preferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
