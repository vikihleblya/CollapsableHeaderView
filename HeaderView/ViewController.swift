//
//  ViewController.swift
//  HeaderView
//
//  Created by Виктор Григорьев on 13.05.2020.
//  Copyright © 2020 Виктор Григорьев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var middleGrayLabel: UILabel!
    
    var headerViewMaxHeight: CGFloat!
    let headerViewMinHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
    }
    
    fileprivate func getHeightOfHeaderView() -> CGFloat {
        let size = CGSize(width: view.frame.width - 32, height: 1000)
        // We remove 32 points because we have leading and trailing constraints to middleGrayLabel
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]
        let estimatedFrame = NSString(string: middleGrayLabel.text ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedFrame.height
    }
    
    fileprivate func setupHeaderView() {
        headerView.clipsToBounds = true
        /* 175 - approximately height of other views, which are always have same size like UIImageView height or bottom label height
         By the way, we can estimate our height as well by the code
         */
        headerViewMaxHeight = getHeightOfHeaderView() + 175.0
        headerViewHeightConstraint.constant = headerViewMaxHeight
    }
    
    fileprivate func changeViewsAlpha(_ y: CGFloat) {
        let totalScroll: CGFloat = 25.0
        let percentage = y / totalScroll
        middleGrayLabel.alpha = (1.0 - percentage)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        changeViewsAlpha(y)
        
        let newHeaderViewHeight: CGFloat = headerViewHeightConstraint.constant - y
        if newHeaderViewHeight > headerViewMaxHeight {
            headerViewHeightConstraint.constant = headerViewMaxHeight
        } else if newHeaderViewHeight < headerViewMinHeight {
            headerViewHeightConstraint.constant = headerViewMinHeight
        } else {
            headerViewHeightConstraint.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0
        }
    }
    
    
}


// All tableView setup including delegate and dataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseId")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
        cell.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        cell.textLabel?.text = "Some cell with text"
        return cell
    }
}
