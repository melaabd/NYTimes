//
//  BaseArticleCell.swift
//  NYTimes
//
//  Created by melaabd on 1/21/22.
//

import UIKit

// MARK: - BaseArticleCell
class BaseArticleCell: UITableViewCell {
    
    @IBOutlet weak var articleImg:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    
    var articleVM: ArticleVM? {
        didSet {
            updateCellData()
        }
    }
    
    /// fill cell data 
    func updateCellData() {
        GCD.onMain { [weak self] in
            guard let self = self, let vm = self.articleVM else { return }
            self.titleLabel.text = vm.title
        }
    }
    
}
