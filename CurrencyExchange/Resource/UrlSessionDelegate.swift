//
//  UrlSessionDelegate.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/4/4.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import Foundation
protocol UrlSessionDelegate {
    func SessionFinish(data:NSData)
    func SessionFinishError(error:NSError)
}
