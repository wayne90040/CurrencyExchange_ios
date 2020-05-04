//
//  mainPresenter.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/4/4.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import Foundation

class MainPresenter: BasePresenter{
    var process = 0
    var status = ""
    var delegate : ViewControllerBaseDelegate?
    init(delegate:ViewControllerBaseDelegate){
        self.delegate = delegate
    }
    
    func getCur(){
        status = "getCur"
        let urlsession = UrlSession(url: ServerContentURL.ip ,delegate:self)
//        let jsonb = JSONBuilder()
//        jsonb.addItem(key: "", value: "")
//        urlsession.setupJSON(json:jsonb.value())
        urlsession.getJSON()
    }
    
    override func SessionFinish(data: NSData) {
        let urlsession = UrlSession()
        let jsondictionary = urlsession.jsonDictionary(json: data)
        let result = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
//        let temp_result = jsondictionary.object(forKey: "result") as! Bool
        delegate?.PresenterCallBack(datadic: jsondictionary, success: true, type: status)
//        if temp_result{
//            delegate?.PresenterCallBack(datadic: jsondictionary, success: true, type: status)
//        }else{
//            delegate?.PresenterCallBack(datadic: jsondictionary, success: false,type:status)
//        }
    }
    override func SessionFinishError(error: NSError) {
        delegate?.PresenterCallBackError(error: error, type: "")
    }
}
