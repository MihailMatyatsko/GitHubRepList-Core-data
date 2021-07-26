//
//  reposTableCell.swift
//  GitHubRepList
//
//  Created by Mihael Matyatsko on 08.07.2021.
//

import UIKit

class reposTableCell: UITableViewCell {

    @IBOutlet weak var reposAvatar: UIImageView!
    @IBOutlet weak var reposFullName: UILabel!
    @IBOutlet weak var repositoryDescription: UILabel!
    @IBOutlet weak var repositoryStars: UILabel!
    
    var html_url_adress: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
        
    }
    
}
