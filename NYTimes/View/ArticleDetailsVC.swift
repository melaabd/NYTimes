//
//  ArticleDetailsVC.swift
//  NYTimes
//
//  Created by melaabd on 1/21/22.
//

import UIKit

class ArticleDetailsVC: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    var articleVM: ArticleVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.reloadData()
    }
    
}

extension ArticleDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailsTVCell.self)) as? DetailsTVCell ?? DetailsTVCell()
        cell.articleVM = articleVM
        guard let imgStringUrl = articleVM.imageUrlString, let mediaUrl = URL(string: imgStringUrl) else { return cell }
        
        if let image = ImgProvider.shared.cache.object(forKey: mediaUrl as NSURL) {
            cell.articleImg.image = image
        } else {
            ImgProvider.shared.requestImage(from :mediaUrl, completion: { (image) -> Void in
                if indexPath == tableView.indexPath(for: cell) {
                    cell.articleImg.image = image
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
