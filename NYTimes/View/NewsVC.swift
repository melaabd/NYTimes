//
//  NewsVC.swift
//  NYTimes
//
//  Created by melaabd on 20/01/2022.
//

import UIKit


/// Binding delegate to connect between VC and VM
protocol BindingVVMDelegate: AnyObject {
    func reloadData()
    func notifyFailure(msg: String)
}


class NewsVC: UIViewController {

    @IBOutlet weak var newsTableview: UITableView!
    var newsVM:NewsVM?
    var spinner:UIView?
    let detailsSegueId = "showArticleDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NY Times Most Popular"
        newsVM = NewsVM()
        newsVM?.bindingDelegate = self
        viewModelCompletions()
        newsVM?.loadNewsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// conform with completions that called in viewmodel
    private func viewModelCompletions() {
        
        // show loading sign
        newsVM?.showLoading = {
            GCD.onMain { [weak self] in
                self?.spinner = self?.view.showSpinner()
            }
        }
        
        // hide loading sign
        newsVM?.hideLoading = {
            GCD.onMain { [weak self] in
                self?.spinner?.remove()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailsSegueId {
            guard let nextVC = segue.destination as? ArticleDetailsVC, let articleVM = sender as? ArticleVM else { return }
            nextVC.articleVM = articleVM
        }
    }

}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noOfRowas = newsVM?.articlesCellVMs?.count ?? 0
        noOfRowas == 0 ? tableView.setEmptyView("No Items Found") : tableView.setEmptyView()
        return noOfRowas
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTVCell.self)) as? NewsTVCell ?? NewsTVCell()
        cell.articleVM = newsVM?.articlesCellVMs?[indexPath.row]
        cell.articleImg.image = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NewsTVCell {
            guard let imgStringUrl = newsVM?.articlesCellVMs?[indexPath.row].thumbnailUrlString, let mediaUrl = URL(string: imgStringUrl) else { return }
            
            if let image = ImgProvider.shared.cache.object(forKey: mediaUrl as NSURL) {
                cell.articleImg.image = image
            } else {
                ImgProvider.shared.requestImage(from :mediaUrl, completion: { (image) -> Void in
                    if indexPath == tableView.indexPath(for: cell) {
                        cell.articleImg.image = image
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleVM = newsVM?.articlesCellVMs?[indexPath.row] else { return }
        performSegue(withIdentifier: detailsSegueId, sender: articleVM)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Conform with BaseVC Binding Protocol
extension NewsVC: BindingVVMDelegate, AlertDelegate {
    /// reload data delegate
    func reloadData() {
        GCD.onMain { [weak self] in
            self?.newsTableview.reloadData()
        }
    }
    
    /// show alert for user in case something went wrong
    /// - Parameter msg: alert message
    func notifyFailure(msg: String) {
        GCD.onMain { [weak self] in
            self?.showAlertWithError(msg, completionHandler: {[weak self] retry in
                if retry {
                    self?.newsVM?.getNews()
                }
            })
        }
    }
}
