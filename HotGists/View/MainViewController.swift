//
//  MainViewController.swift
//  HotGists
//
//  Created by Binghui Zhong on 26/2/2022.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {
    
    var mainViewModel = MainViewModel()
    var gists = [Gist]()
    
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        tableView.backgroundColor = .cyan
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableCell")
        tableView.estimatedRowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpBinding()
        mainViewModel.requestData()
    }
    
    func setUpBinding() {
        mainViewModel
            .gists
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { values in
                self.gists = values
            }, onError: { error in
                print(error)
            }, onCompleted: {
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableViewCell
        cell.setUpData(gists[indexPath.row])
        return cell
    }
    
    
}
