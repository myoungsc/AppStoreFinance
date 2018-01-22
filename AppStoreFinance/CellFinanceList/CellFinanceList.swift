//
//  CellFinanceList.swift
//  AppStoreFinance
//
//  Created by maccli1 on 2018. 1. 16..
//  Copyright © 2018년 myoung. All rights reserved.
//

import UIKit

class CellFinanceList: UITableViewCell {

    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbRank: UILabel!
    @IBOutlet weak var lbtitle: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var btnOpenAndDown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ivIcon.layer.cornerRadius = 10.0
        ivIcon.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        ivIcon.layer.borderWidth = 0.5
        ivIcon.layer.masksToBounds = true
        
        btnOpenAndDown.layer.cornerRadius = btnOpenAndDown.frame.size.width/4.0        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
