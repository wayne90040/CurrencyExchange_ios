//
//  ViewControllerBaseDelegate.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/4/4.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import UIKit
protocol ViewControllerBaseDelegate {
    func PresenterCallBack(datadic:NSDictionary,success:Bool,type:String)
    func PresenterCallBackError(error:NSError,type:String)
}

