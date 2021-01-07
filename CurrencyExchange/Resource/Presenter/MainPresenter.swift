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
        urlsession.getJSON()
    }
    
    override func SessionFinish(data: NSData) {
        let urlsession = UrlSession()
        let jsondictionary = urlsession.jsonDictionary(json: data)
        let result = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        delegate?.PresenterCallBack(datadic: jsondictionary, success: true, type: status)
    }
    
    override func SessionFinishError(error: NSError) {
        delegate?.PresenterCallBackError(error: error, type: "")
    }
}
