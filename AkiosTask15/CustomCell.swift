//
//  CustomCell.swift
//  AkiosTask15
//
//  Created by Nekokichi on 2020/08/22.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet private(set) weak var checkItemImage: UIImageView!
    @IBOutlet private(set) weak var checkItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text:String, keyCheck:Bool) {
        //チェックマークの画像を表示
        if keyCheck {
            checkItemImage.image = UIImage(systemName: "checkmark")
        } else {
            checkItemImage.image = UIImage(systemName: "")
        }
        //チェックリストのテキストを表示
        checkItemLabel.text = text
    }
    
}
