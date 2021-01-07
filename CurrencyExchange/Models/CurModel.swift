//
//  CurModel.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/4/7.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import Foundation


class CurCodable: Codable {
    var COPPERHIGHGRADE: CurDetail?
    var PALLADIUM1OZ: CurDetail?
    
    var USD: CurDetail?
    var USDTWD: CurDetail? // 美金 -> 台幣
    var USDJPY: CurDetail? // 美金 -> 日幣
    var USDAUD: CurDetail?
    var USDCAD: CurDetail?
    var USDGBP: CurDetail?
    
    var countries: Array<CurDetail>?

    class CurDetail: Codable {
        var country: String?
        var imageString: String?
        var exchange: Double?
        var Exrate: Double
        var UTC: String
        
        internal func setnowExchange(exchange: Double, exrate: Double, USD: Bool){
            // 本金 利率
            if USD{  // USD 直接換
                self.exchange = exchange * exrate
            }else{
                if country == "USD"{ // 非 USD 須先換成 USD 在換他國 匯率
                    self.exchange = exchange * 1 / exrate
                }else{
                    self.exchange = exchange / exrate * Exrate
                }
            }
        }
        
        internal func getExchange() -> Double{
            return self.exchange ?? 99
        }
    }
    
    internal func getAllCountry() -> Array<CurDetail>{
        USD?.country = "USD"
        USD?.imageString = "usa.png"
        
        USDTWD?.country = "TWD"
        USDTWD?.imageString = "taiwan.jpg"
        
        USDJPY?.country = "JPY"
        USDJPY?.imageString = "japan.png"
        
        USDAUD?.country = "AUD"
        USDAUD?.imageString = "aud.png"
        
        USDGBP?.country = "GBP"
        USDGBP?.imageString = "GBP.png"
        
        USDCAD?.country = "CAD"
        USDCAD?.imageString = "canada.png"
        
        return [USD!, USDTWD!, USDAUD!, USDJPY!, USDGBP!, USDCAD!]
    }
}
