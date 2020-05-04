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
    
    
    class CurDetail: Codable {
        var country: String?
        var exchange: Double?
        
        var Exrate: Double
        var UTC: String
        
        internal func setnowExchange(exchange: Double, exrate: Double, USD: Bool){
            // 本金 利率
            
            if USD{
                self.exchange = exchange * exrate

            }else{
                if country == "USD"{
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
        USDTWD?.country = "TWD"
        USDJPY?.country = "JPY"
        
        return [USD!, USDJPY!, USDTWD!]
    }
    
}
