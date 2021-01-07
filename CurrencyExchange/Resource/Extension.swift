//
//  Extension.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2021/1/7.
//  Copyright © 2021 Wei Lun Hsu. All rights reserved.
//

import Foundation

extension Double {
    // 四捨五入至 小數第x位
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}
