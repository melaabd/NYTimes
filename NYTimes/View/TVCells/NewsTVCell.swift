//
//  NewsTVCell.swift
//  NYTimes
//
//  Created by melaabd on 1/21/22.
//

import UIKit

class NewsTVCell: BaseArticleCell {
    
    @IBOutlet weak var byLineLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        articleImg.layer.cornerRadius = articleImg.frame.height / 2
    }
    
    override func updateCellData() {
        super.updateCellData()
        
        GCD.onMain { [weak self] in
            guard let self = self, let vm = self.articleVM else { return }
            self.byLineLabel.text = vm.byline
            self.dateLabel.text = vm.publishedDate
        }
    }
}
