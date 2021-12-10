//
//  SquareCollectionViewCell.swift
//  Background
//
//  Created by Luís Filipe Nascimento on 05/12/21.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "SquareCollectionViewCell"

    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
    }
    
    func configure(with number: Int) {
        self.numberLabel.text = String(format: "%03d", number)
    }

}
