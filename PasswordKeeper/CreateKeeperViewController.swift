

import UIKit
import CoreData
import AVFoundation

class CreateKeeperViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var serviceName: UITextField!
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var memoContent: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImageIndex = 0
    var timer: Timer?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceName.delegate = self
        loginName.delegate = self
        loginPassword.delegate = self
        memoContent.delegate = self
        
        let item = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saved))
        navigationItem.rightBarButtonItem = item
        
        imageView.contentMode = .scaleAspectFit
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc func saved() {
        
        if let serviceName = serviceName.text, let loginName = loginName.text, let loginPassword = loginPassword.text, let memeoContent = memoContent.text{
            
            self.save(serviceName: serviceName, loginName: loginName, loginPassword: loginPassword, memeoContent: memeoContent)
            
            playSound()
             
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    @objc func changeImage() {
        
        let imageNames = ["Frame 1", "Frame 2", "Frame 3", "Frame 4"]
        
        // 画像のインデックスを更新
        currentImageIndex = (currentImageIndex + 1) % imageNames.count
        
        // 画像の表示
        let imageName = imageNames[currentImageIndex]
        let image = UIImage(named: imageName)
        imageView.image = image
        }
    
    func save(serviceName: String, loginName: String, loginPassword: String, memeoContent: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Card",
                                   in: managedContext)!
      
      let cards = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
        cards.setValue(serviceName, forKeyPath: "serviceName")
        cards.setValue(loginName, forKey: "loginName")
        cards.setValue(loginPassword, forKeyPath: "loginPassword")
        cards.setValue(memeoContent, forKeyPath: "memoContent")
      
      // 4
      do {
        try managedContext.save()
          cardContents.append(cards)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // テキストフィールドが編集状態になった時に呼ばれる
        textField.becomeFirstResponder() // キーボードを表示する
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 他のViewがタップされた時に呼ばれる
        view.endEditing(true) // キーボードを閉じる
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "createSound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }



}
