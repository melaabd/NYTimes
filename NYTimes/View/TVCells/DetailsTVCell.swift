//
//  DetailsTVCell.swift
//  NYTimes
//
//  Created by melaabd on 1/21/22.
//

import UIKit

class DetailsTVCell: BaseArticleCell {

    @IBOutlet weak var abstractTxtView: UITextView!
    
    override func updateCellData() {
        super.updateCellData()
        
        GCD.onMain { [weak self] in
            guard let self = self, let vm = self.articleVM else { return }
            self.abstractTxtView.text = vm.abstract
        }
    }

}
