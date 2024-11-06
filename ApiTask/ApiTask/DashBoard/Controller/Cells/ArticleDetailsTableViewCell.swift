//
//  ArticleDetailsTableViewCell.swift
//  ApiCall
//
//  Created by Kishore B on 11/6/24.
//

import UIKit

class ArticleDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureData(with data: Doc?) {
        cardView.applyCardShadow()
        self.titleLabel.text = data?.headline?.main ?? ""
        self.descLabel.text = "\(data?.abstract ?? "")"
        self.dateLabel.text = displayFormattedDate(data?.pubDate ?? "")
    }
    
    private func displayFormattedDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

