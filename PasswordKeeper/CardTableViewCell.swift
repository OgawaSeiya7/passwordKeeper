//
//  CardTableViewCell.swift
//  PasswordKeeper
//
//  Created by 小川星哉 on 2023/05/25.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var loginName: UILabel!
    @IBOutlet weak var loginPassword: UILabel!
    @IBOutlet weak var memoContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        serviceName.font = UIFont.boldSystemFont(ofSize: 25)
        
        
        cardViewBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected stateセルが選択された時に特定の背景色やアニメーションを設定する、選択されたセルの表示を変更するなどのカスタム処理を追加することができます。
        
    }
    
    func cardViewBorder() {
        cardView.layer.borderWidth = 3.0 // 枠線の幅を設定
        cardView.layer.borderColor = UIColor.black.cgColor // 枠線の色を設定
        
        cardView.layer.cornerRadius = 10.0 // 角丸の半径を設定
        cardView.layer.masksToBounds = true // 角丸を適用するために必要な設定

    }
    
}
