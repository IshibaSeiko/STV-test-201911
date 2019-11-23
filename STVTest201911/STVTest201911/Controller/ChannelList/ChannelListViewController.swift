//
//  ChannelListViewController.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import UIKit

class ChannelListViewController: UIViewController {
    
    @IBOutlet weak var channelListTable: UITableView!
    
    var channelListDBData:[ChannelListData]?
    var navigationTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        navigationController?.navigationItem.title = navigationTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let swipe:UISwipeGestureRecognizer
        swipe = UISwipeGestureRecognizer()
        swipe.direction = .down
        swipe.numberOfTouchesRequired = 1
        swipe.addTarget(self, action: #selector(self.popVC))
        self.view.addGestureRecognizer(swipe)
        
        channelListTable.delegate = self
        channelListTable.dataSource = self
        channelListTable.reloadData()
    }
}

extension ChannelListViewController {
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChannelListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !Network.isOnline() {
            return
        }
        
        guard let data = channelListDBData,
            let url = URL(string: data[indexPath.row].link) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Cannot open URL")
        }
    }
}

extension ChannelListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelListDBData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "ChannelListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChannelListTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelListTableViewCell", for: indexPath)
        guard let channelListCell = cell as? ChannelListTableViewCell,
        let data = channelListDBData else {
            return cell
        }
        channelListCell.setLayout(data: data[indexPath.row])
        return channelListCell
    }
}

