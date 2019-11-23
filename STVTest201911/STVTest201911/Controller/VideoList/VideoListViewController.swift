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

    @IBOutlet weak var videoListTableView: UITableView!
    let videoList = VideoListDao()
    var VideoListDBData: [VideoListData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    func setUp() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let apiClient = APIClient()
        apiClient.fetchVideoList(endPoint: movieListEndPoint) { (result) in
            switch result {
            case .success(let data):
                self.decodeMovieList(data: data)
            case .failure(let error):
                print(error)
            }
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
        VideoListDBData = Array(videoList.findAll())
        videoListTableView.reloadData()
    }
}

extension VideoListViewController: UITableViewDelegate {

}

extension VideoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if VideoListDBData.count < 1 {
            return 1
        } else {
            return VideoListDBData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if VideoListDBData.count < 1 {
            tableView.register(UINib(nibName: "NoVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "NoVideoTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoVideoTableViewCell", for: indexPath)
            return cell
        }

        tableView.register(UINib(nibName: "VideoListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoListTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath)
        guard let movieListCell = cell as? VideoListTableViewCell else {
            return cell
        }
        movieListCell.setLayout(data: VideoListDBData[indexPath.row])
        return movieListCell
    }
}
