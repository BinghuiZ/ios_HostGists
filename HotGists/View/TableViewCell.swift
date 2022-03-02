//
//  tableViewCell.swift
//  HotGists
//
//  Created by Binghui Zhong on 27/2/2022.
//

import UIKit
import SnapKit

protocol CustomCellDelegate {
    func favouriteButtonClicked(id: String)
}

class TableViewCell: UITableViewCell {
    
    var delegate: CustomCellDelegate?
    var gist: GistUIModel?
    
    private let idLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    private let urlLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let fileLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    private let favouriteImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
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
        stackView.addArrangedSubview(favouriteImageView)
        urlLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        favouriteImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        favouriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favouriteButtonClicked)))
    }
    
    @objc func favouriteButtonClicked() {
        if let isFavourite = gist?.isFavouriteItem {
            favouriteImageView.image = UIImage(systemName: !isFavourite ? "heart.fill" : "heart")
        }
        delegate?.favouriteButtonClicked(id: gist?.gist.id ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        idLbl.text = "ID: "
        urlLbl.text = "URL: "
        fileLbl.text = "FileName: "
    }
    
    func setUpData(_ gist: GistUIModel) {
        self.gist = gist
        
        idLbl.text = "ID: \(gist.gist.id)"
        urlLbl.text = "URL: \(gist.gist.url)"
        fileLbl.text = "FileName: \(gist.gist.files.array.first?.filename ?? "")"
        favouriteImageView.image = UIImage(systemName: gist.isFavouriteItem ? "heart.fill" : "heart")
    }
}
