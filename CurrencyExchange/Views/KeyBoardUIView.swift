//
//  KeyBoardUIView.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/5/6.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import UIKit

class KeyBoardUIView: UIView {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hideKeyButton: UIButton!
    var delegate: KeyBoardDelegate!
    var tmpExchange = 0
    var tmpFloat = 0
    var floatBool = false
    
    @IBAction func cleanAction(_ sender: UIButton) {
        tmpExchange = 0
        tmpFloat = 0
        floatBool = false
        delegate?.reloadExchange(exchange: 0.0)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        var exchange = Double()
        if tmpFloat != 0 && floatBool {
            let len = tmpFloat.description.count
            tmpFloat = tmpFloat / 10
            exchange = Double(tmpExchange) + Double(tmpFloat) / Double(NSDecimalNumber(decimal: pow(10, len - 1)))
        }else{
            tmpExchange = tmpExchange / 10
            exchange = Double(tmpExchange)
        }
        
        if tmpFloat == 0 && floatBool{
            floatBool = false
        }
        
        delegate.reloadExchange(exchange: exchange)
    }
    
    @IBAction func pointAction(_ sender: Any) {
        floatBool = true
    }
    
    @IBAction func numbersAction(_ sender: UIButton) {
        let tag = sender.tag
        var exchange = Double()
        
        if floatBool{
            if tmpFloat == 0{
                tmpFloat = tag
            }else{
                tmpFloat = Int(tmpFloat.description + tag.description)!
            }
        }else{
            if tmpExchange == 0{
                tmpExchange = tag
            }else{
                tmpExchange = Int(tmpExchange.description + tag.description)!
            }
        }
        
        if tmpFloat == 0{
            exchange = Double(tmpExchange)
        }else{
            let len = tmpFloat.description.count
    
            exchange = Double(tmpExchange) + Double(tmpFloat) / Double(NSDecimalNumber(decimal: pow(10, len)))
        }

        delegate.reloadExchange(exchange: exchange)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "KeyBoardUIView", bundle: bundle)
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        addSubview(xibView)
        
        // set xibView Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}
