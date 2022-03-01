//
//  DetailPageViewController.swift
//  HotGists
//
//  Created by Binghui Zhong on 1/3/2022.
//

import UIKit
import SnapKit
import RxSwift

class DetailPageViewController: UIViewController {
    
    var gist: Gist?
    var detail: Detail?
    
    var mainViewModel = MainViewModel()
    let disposeBag = DisposeBag()
    
    private let fileNameLbl: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .label
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setUpBinding()
        if let gist = gist {
            mainViewModel.requestDetail(user: gist.owner.login)
        }
    }
    
    func initUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(fileNameLbl)
        fileNameLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setUpBinding() {
        mainViewModel
            .detail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
                self.detail = value
                self.updateUI()
            }, onError: { error in
                print(error)
            }, onCompleted: {
                
            })
            .disposed(by: disposeBag)
    }
    
    func updateUI() {
        fileNameLbl.text = detail?.files.array.first?.filename
    }
    
}
