

import UIKit
import CoreData


var cardContents: [NSManagedObject] = []

class ViewController: UIViewController {
    
//    komennto
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "card"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = false
        
        
        
        let navigationItemRight = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(rightButtonTapped))
        
        navigationItem.rightBarButtonItem = navigationItemRight
        
        tableView.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func rightButtonTapped() {
        // ボタンがタップされた時の処理を記述
        let nextVCIdentifier = "createKeeper"
        
        if let createKeeperVC = storyboard?.instantiateViewController(withIdentifier: nextVCIdentifier) as? CreateKeeperViewController {
            // createKeeperVCを使用して必要な処理を実行
            // 例: createKeeperVCのプロパティを設定したり、遷移を行ったりする
            // ...
            navigationController?.pushViewController(createKeeperVC, animated: true)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewWillApper")
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Card")
        
        //3
        do {
            cardContents = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
        
        // cardContentsが空であるかチェック
        if cardContents.isEmpty {
            // Iconという名前の画像を作成
            let iconImage = UIImage(named: "Icon")
            
            // UIImageViewを作成し、Icon画像を設定
            let imageView = UIImageView(image: iconImage)
            
            // UIImageViewのサイズを設定
            let imageSize = CGSize(width: 100, height: 100)
            imageView.frame = CGRect(origin: CGPoint.zero, size: imageSize)
            
            // 画面の中央に配置するための計算
            let viewCenter = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            let imageOrigin = CGPoint(x: viewCenter.x - imageSize.width/2, y: viewCenter.y - imageSize.height/2)
            imageView.frame.origin = imageOrigin
            
            view.addSubview(imageView)
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cardContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CardTableViewCell
        
        let card = cardContents[indexPath.row]
        cell.serviceName.text = card.value(forKeyPath: "serviceName") as? String
        cell.loginName.text = card.value(forKeyPath: "loginName") as? String
        cell.loginPassword.text = card.value(forKeyPath: "loginPassword") as? String
        cell.memoContent.text = card.value(forKeyPath: "memoContent") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // UIAlertControllerを作成
        let alertController = UIAlertController(title: "確認", message: "削除してもよろしいですか？", preferredStyle: .alert)
        
        // OKボタンを作成
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            // OKボタンが押された時の処理
            // ここに実行したいコードを書く
            if editingStyle == .delete {
                // 削除処理を実行
                let deleteContent = cardContents.remove(at: indexPath.row) // 削除したいデータを配列から削除
                
                guard let appDelegate =
                        UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                // 1
                let managedContext =
                appDelegate.persistentContainer.viewContext
                
                managedContext.delete(deleteContent)
                tableView.deleteRows(at: [indexPath], with: .fade) // セルを削除
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        }
        
        // キャンセルボタンを作成
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
            // キャンセルボタンが押された時の処理
            // ここに実行したいコードを書く
            return
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        // アクションボタンをUIAlertに追加
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // UIAlertControllerを表示
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    
    
    
}

