//
//  NormalWidgetTableViewCell.swift
//  CurrencyExchangeWidget
//
//  Created by Wei Lun Hsu on 2020/7/7.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import UIKit

class NormalWidgetTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
