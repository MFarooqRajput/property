//
//  RoomsTableViewCell.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-17.
//

import UIKit

class RoomsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roomsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(with rooms: Int) {
        roomsLabel.text = "\(rooms)"
    }
    
}
