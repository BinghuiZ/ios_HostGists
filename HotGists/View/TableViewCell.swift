//
//  tableViewCell.swift
//  HotGists
//
//  Created by Binghui Zhong on 27/2/2022.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    private let idLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    private let urlLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    private let fileLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.contentView.backgroundColor = .gray
//        self.contentView.layer.cornerRadius = 10
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.backgroundColor = .gray
        stackView.layer.cornerRadius = 10
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        stackView.addArrangedSubview(idLbl)
        stackView.addArrangedSubview(urlLbl)
        stackView.addArrangedSubview(fileLbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        idLbl.text = ""
        urlLbl.text = ""
        fileLbl.text = ""
    }
    
    func setUpData(_ gist: Gist) {
        idLbl.text = gist.id
        urlLbl.text = gist.url
        fileLbl.text = gist.files.array.first?.filename ?? ""
    }
}
