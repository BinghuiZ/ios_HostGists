//
//  MainViewController.swift
//  HotGists
//
//  Created by Binghui Zhong on 26/2/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        
        mainViewModel.requestData()
    }
    
}
