//
//  PropertyListTableViewCell.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import UIKit

protocol PropertyListTableViewCellDelegate : class {
    func didTapBooking(cell: PropertyListTableViewCell)
    func didTapBooked(cell: PropertyListTableViewCell)
}

class PropertyListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var bookButton: CustomButton!
    @IBOutlet weak var booked: CustomButton!
    
    weak var delegate: PropertyListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(with property: Property, isBooked: Bool) {
        nameLabel.text = property.name
        roomsLabel.text = "Bed Rooms:" + "\(property.bedrooms)"
        bookButton.isHidden = isBooked
        booked.isHidden = !isBooked
        latitudeLabel.text = "Latitude:" + "\(property.latitude)"
        longitudeLabel.text = "Longitude:" + "\(property.longitude)"
    }
    
    @IBAction func bookingTapped(_ sender: UIButton) {
        delegate?.didTapBooking(cell: self)
    }
    
    @IBAction func bookedTapped(_ sender: UIButton) {
        //delegate?.didTapBooked(cell: self)
    }
    
}
