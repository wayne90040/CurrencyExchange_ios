//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/4/4.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var mainpresenter: MainPresenter?
    var curcodable: CurCodable?
    var loadactivity = LoadActivity()
    var editIndex = Int()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainpresenter = MainPresenter(delegate: self)
        mainpresenter?.getCur()
        loadactivity.showActivityIndicator(self.view)
        
        let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: "Cell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 100
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController: ViewControllerBaseDelegate, UITableViewDelegate, UITableViewDataSource, MainTableViewCellDelegate{
    
    func getCellIndex(_ sender: MainTableViewCell) {
        guard let index = mainTableView.indexPath(for: sender) else {return}
        editIndex = index.row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        let country = curcodable?.getAllCountry()[indexPath.row]
        var exchange = Double()
        
        if country?.exchange != nil{
            exchange = country?.getExchange().rounding(toDecimal: 2) ?? 00
            let intExchange = Double(Int(exchange))
            
            if exchange - intExchange == 0 {
                cell.exchangeTxt.text = Int(exchange).description
            }else{
                cell.exchangeTxt.text = exchange.description
            }
            
//            cell.exchangeTxt.placeholder = exchange.description
        }else{
            exchange = country?.Exrate.rounding(toDecimal: 2) ?? 00
            cell.exchangeTxt.placeholder = exchange.description
       
        }
        
        cell.delegate = self
        cell.countryLbl.text = country?.country ?? " "
//        cell.exchangeTxt.keyboardType = .numberPad
        cell.exchangeTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return cell
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let countries = (curcodable?.getAllCountry())!
        let editcountry = curcodable?.getAllCountry()[editIndex]
        var exchange: Double?
        
        if Double(textField.text!) != nil{
            exchange = Double(textField.text!)!
        }else{
            let alert = UIAlertController(title: "請輸入數值", message: "請輸入數值", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(confirm)
            exchange = 0
            present(alert, animated: true, completion: nil)
        }
        editcountry?.setnowExchange(exchange: exchange!, exrate: editcountry!.Exrate, USD: false)
        
        if editcountry?.country == "USD"{ // USD
            for country in countries{
                if country.country != "USD"{
                    country.setnowExchange(exchange: exchange!, exrate: country.Exrate, USD: true)
                }
            }
           mainTableView.reloadData()
            
        }else{
            for country in countries{
                if country.country != editcountry?.country && country.country != "USD" {
                    country.setnowExchange(exchange: exchange!, exrate: editcountry!.Exrate, USD: false)
                }else if country.country == "USD"{
                    country.setnowExchange(exchange: exchange!, exrate: editcountry!.Exrate, USD: false)
                }else{
                    
                }
            }
            mainTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func PresenterCallBack(datadic: NSDictionary, success: Bool, type: String) {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
            self.curcodable = try JSONDecoder().decode(CurCodable.self, from: jsonData)
            
            DispatchQueue.main.sync {
                mainTableView.reloadData()
                self.loadactivity.hideActivityIndicator(self.view)
            }
        }catch{
            print("Error")
        }
    }
    
    func PresenterCallBackError(error: NSError, type: String) {
        
    }
}

 // 四捨五入至 小數第x位
extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}

