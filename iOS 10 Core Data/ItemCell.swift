//
//  ItemCell.swift
//  iOS 10 Core Data
//
//  Created by Peter Leung on 18/11/2016.
//  Copyright © 2016 winandmac Media. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    func configureCell(item: Item){
        lblTitle.text = item.title
        lblPrice.text = "$\(item.price)"
        lblDetails.text = item.details
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
