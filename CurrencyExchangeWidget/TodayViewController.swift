//
//  TodayViewController.swift
//  CurrencyExchangeWidget
//
//  Created by Wei Lun Hsu on 2020/7/5.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var mainTableView: UITableView!
    var countries = Array<String>(), exchanges = Array<Double>(), imgs = Array<String>()
    let userdefault = UserDefaults(suiteName: "group.WeiLun.CurrencyExchange")
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell
        let nib = UINib(nibName: "NormalWidgetTableViewCell", bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: "Cell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        // Allow widget to be expanded or contracted.
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        countries = userdefault?.value(forKey: "Countries") as? [String] ?? []
        exchanges = userdefault?.value(forKey: "Exchange") as? [Double] ?? []
        imgs = userdefault?.value(forKey: "Png") as? [String] ?? []
        mainTableView.reloadData()
    }
    
    // MARK: - Widget protocol
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            let height = CGFloat(60 * countries.count)
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        default:
            break
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - TableView DataSource & TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NormalWidgetTableViewCell
        let row = indexPath.row
        
        cell.countryLabel.text = countries[row]
        cell.exchangeLabel.text = exchanges[row].description
        cell.countryImg.image = UIImage(named: imgs[row])
        cell.countryImg.layer.cornerRadius = 20
        cell.countryImg.clipsToBounds = true
        
        return cell
    }

}
