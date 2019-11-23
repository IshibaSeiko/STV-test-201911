//
//  VideoListViewController.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import UIKit

class VideoListViewController: UIViewController {
    
    let movieListEndPoint = "/videos"
    let channelListEndPoint = "/channels"

    @IBOutlet weak var videoListTableView: UITableView!
    let videoList = VideoListDao()
    let channelList = ChannelListDao()
    
    var videoListDBData: [VideoListData] = []
    
    var activityIndicatorView = UIActivityIndicatorView()
    var start: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadListData()
        self.setUp()
    }
    
    func setUp() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        
        view.addSubview(activityIndicatorView)
        if Network.isOnline() {
            let workItem = DispatchWorkItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.activityIndicatorView.startAnimating()
                }
            }

            let apiClient = APIClient()
            apiClient.fetchVideoList(endPoint: movieListEndPoint) { (result) in
                
                switch result {
                case .success(let data):
                    self.decodeMovieList(data: data)
                case .failure(let error):
                    print(error)
                }
                workItem.cancel()
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
            }
        } else {
            print("isOffline")
        }
        
        videoListTableView.delegate = self
        videoListTableView.dataSource = self
    }
    
    func decodeMovieList(data: Data) {
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(MovieList.self, from: data) else {
            return
        }
        videoList.deleteAll()
        videoList.add(objects: setMovieListDataFromAPI(data: decodeData))
        print(decodeData)
        reloadListData()
    }
    
    func reloadListData() {
        videoListDBData = Array(videoList.findAll())
        videoListTableView.reloadData()
    }
}

extension VideoListViewController {
    func decodeChannelList(data: Data) {
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(ChannelList.self, from: data) else {
            return
        }
        
        channelList.deleteAll()
        channelList.add(objects: setChannelListDataFromAPI(data: decodeData))
    }
}

extension VideoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if videoListDBData.count == 0 {
            return
        }
        
        if Network.isOnline() {
            let workItem = DispatchWorkItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.activityIndicatorView.startAnimating()
                }
            }
            let apiClient = ChannelListAPIClient()
            apiClient.fetchChannelList(endPoint: channelListEndPoint, parameter: videoListDBData[indexPath.row].id) { (result) in
                switch result  {
                case .success(let data):
                    self.decodeChannelList(data: data)
                case .failure(let error):
                    print(error)
                }
                workItem.cancel()
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
            }
        } else {
            print("isOffline")
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "ChannelListViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ChannelListViewController") as? ChannelListViewController else {
            return
        }
        vc.channelListDBData = Array(channelList.findAll())
        vc.navigationTitle = videoListDBData[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VideoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if videoListDBData.count < 1 {
            return 1
        } else {
            return videoListDBData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if videoListDBData.count < 1 {
            tableView.register(UINib(nibName: "NoVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "NoVideoTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoVideoTableViewCell", for: indexPath)
            return cell
        }

        tableView.register(UINib(nibName: "VideoListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoListTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath)
        guard let movieListCell = cell as? VideoListTableViewCell else {
            return cell
        }
        movieListCell.setLayout(data: videoListDBData[indexPath.row])
        return movieListCell
    }
}
