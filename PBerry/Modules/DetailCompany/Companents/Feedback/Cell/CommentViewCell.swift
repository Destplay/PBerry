//
//  CommentViewCell.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setup(_ comment: CommentViewModel) {
        self.titleLabel.text = comment.name
        self.subtitleLabel.text = comment.message
        self.dateLabel.text = comment.date
        self.statusLabel.text = comment.status
    }

}
