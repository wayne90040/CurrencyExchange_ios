//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/4/4.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import UIKit

protocol KeyBoardDelegate {
    func reloadExchange(exchange: Double)
}

class ViewController: UIViewController{
    var mainpresenter: MainPresenter?
    var curcodable: CurCodable?
    var loadactivity = LoadActivity()
    var editIndex = Int(), exchange = Double()
    let keyBoardView = KeyBoardUIView()
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadactivity.showActivityIndicator(self.view)
        // Do any additional setup after loading the view.
        mainpresenter = MainPresenter(delegate: self)
        mainpresenter?.getCur()
        
        let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: "Cell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setKeyBoard(){
//        guard let window = UIApplication.shared.keyWindow else { return }
        keyBoardView.translatesAutoresizingMaskIntoConstraints = false
       
        let top = NSLayoutConstraint(item: keyBoardView,  attribute: .bottom, relatedBy: .equal,  toItem: mainView, attribute: .bottom,  multiplier: 1.0, constant: 0)
        let height = NSLayoutConstraint(item: keyBoardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 320.0)
        let left = NSLayoutConstraint(item: keyBoardView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0)
        let right = NSLayoutConstraint(item: keyBoardView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        keyBoardView.hideKeyButton.addTarget(self, action: #selector(hideKeyBoard), for: .touchUpInside)
        keyBoardView.delegate = self
        keyBoardView.floatBool = false // Init KeyBoard
        keyBoardView.tmpExchange = 0
        keyBoardView.tmpFloat = 0
        
//        window.addSubview(keyBoardView)
        mainView.addSubview(keyBoardView)
        mainView.addConstraint(top)
        mainView.addConstraint(height)
        mainView.addConstraint(left)
        mainView.addConstraint(right)
    }
    
    @objc func hideKeyBoard(){
        for view in mainView.subviews{
            if view == keyBoardView{
//                tableViewBottom.constant = CGFloat(0.0)
                mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
                view.removeFromSuperview()
                break
            }
        }
    }
}

extension ViewController: ViewControllerBaseDelegate, UITableViewDelegate, UITableViewDataSource, KeyBoardDelegate{
   
    func reloadExchange(exchange: Double) {
        let countries = (curcodable?.getAllCountry())
        let editcountry = curcodable?.getAllCountry()[editIndex]

        editcountry?.setnowExchange(exchange: exchange, exrate: editcountry?.Exrate ?? 0, USD: false)
        
        if editcountry!.country == "USD"{ // USD
            for country in countries!{
                if country.country != "USD"{
                    country.setnowExchange(exchange: exchange, exrate: country.Exrate, USD: true)
                }
            }
           mainTableView.reloadData()
            
        }else{
            for country in countries!{
                if country.country != editcountry?.country && country.country != "USD" {
                    country.setnowExchange(exchange: exchange, exrate: editcountry?.Exrate ?? 0, USD: false)
                }else if country.country == "USD"{
                    country.setnowExchange(exchange: exchange, exrate: editcountry?.Exrate ?? 0, USD: false)
                }else{
                    
                }
            }
            mainTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curcodable?.getAllCountry().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        let country = curcodable?.getAllCountry()[indexPath.row]
        var exchange = Double()
        
        if country?.exchange != nil{
            exchange = country?.getExchange().rounding(toDecimal: 5) ?? 00
            let intExchange = Double(Int(exchange))
            
            if exchange - intExchange == 0 {
                cell.exchangeLbl.text = Int(exchange).description
            }else{
                cell.exchangeLbl.text = exchange.description
            }
        }else{
            exchange = country?.Exrate.rounding(toDecimal: 5) ?? 00
            cell.exchangeLbl.text = exchange.description
        }
    
        cell.countryLbl.text = country?.country ?? " "
        cell.countryImg.image = UIImage(named: country?.imageString ?? "")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editIndex = indexPath.row
        setKeyBoard() //
        mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 320, right: 0) // keyboard size
        mainTableView.scrollToRow(at: indexPath, at: .middle, animated: true) // scroll to cell
    }
    
    func PresenterCallBack(datadic: NSDictionary, success: Bool, type: String) {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
            self.curcodable = try JSONDecoder().decode(CurCodable.self, from: jsonData)
            print(datadic)
           
            DispatchQueue.main.sync {
                mainTableView.reloadData()
                self.loadactivity.hideActivityIndicator(self.view)
            }
        }catch{}
    }
    
    func PresenterCallBackError(error: NSError, type: String) {}
}

 // 四捨五入至 小數第x位
extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}

