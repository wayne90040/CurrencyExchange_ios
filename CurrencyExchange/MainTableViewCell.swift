//
//  MainTableViewCell.swift
//  CurrencyExchange
//
//  Created by Wei Lun Hsu on 2020/4/4.
//  Copyright © 2020 Wei Lun Hsu. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var exchangeTxt: UITextField!
    @IBAction func exchangeBegain(_ sender: UITextField) {
        delegate?.getCellIndex(self)
    }
    
    var delegate: MainTableViewCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol MainTableViewCellDelegate {
    func getCellIndex(_ sender: MainTableViewCell)
}
