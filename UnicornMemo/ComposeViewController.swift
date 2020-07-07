import UIKit
import GoogleMobileAds

extension NSNotification.Name {
    static let memoDidInsert = NSNotification.Name(rawValue: "MemoDidInsert")
    //    static let memoDidEdit = NSNotification.Name(rawValue: "MemoDidEdit")
}

class ComposeViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    //var editTarget: MemoEntity?
    var interstitial1: GADInterstitial!
    let saveButton = UIButton(type: UIButton.ButtonType.custom)
    var originalMemoContent: String?
    var bannerView3: GADBannerView!
    @IBOutlet weak var textView: UITextView!
    @objc func saveMemo(_ sender: Any) {
        guard let text = textView.text, text.count > 0 else {
            let alert = UIAlertController(title: "Alert", message: "Require contents!", preferredStyle:.alert)
            let ok = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
                self?.textView.becomeFirstResponder()
            }
            alert.addAction(ok)
            self.present(alert, animated: true)
            return
        }
        //        if let memo = editTarget {
        //            memo.content = text
        //            CoreDataManager.shared.saveContext()
        //            NotificationCenter.default.post(name: .memoDidEdit, object: nil)
        //        } else {
        CoreDataManager.shared.createMemo(content: text)
        NotificationCenter.default.post(name: .memoDidInsert, object: nil)
        //            self.cancelMemo(sender)
        textView.resignFirstResponder()
        saveButton.isEnabled = false
    }
    @objc func cancelMemo(_ sender: Any) {
            let save = UserDefaults.standard
            if save.value(forKey: "Purchase") == nil {
                if (self.interstitial1.isReady) {
                    self.interstitial1.present(fromRootViewController: self)
                    self.interstitial1 = self.createAd()
                } else { self.dismiss(animated: true, completion: nil)}
            } else {
                self.interstitial1 = nil
                self.dismiss(animated: true, completion: nil)
            }
    }
    func createAd() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: "ca-app-pub-8233515273063706/7401150820")
        inter.load(GADRequest())
        return inter
    }
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func setupBannerView() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
        bannerView3 = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView3)
        bannerView3.adUnitID = "ca-app-pub-8233515273063706/1290726984"
        bannerView3.rootViewController = self
        bannerView3.load(GADRequest())
        bannerView3.delegate = self
    }
    func setupBannerViewOriginal() {
           let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
           bannerView3 = GADBannerView(adSize: adSize)
       }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
       let save = UserDefaults.standard
               if save.value(forKey: "Purchase") == nil {
                 setupBannerView()
           } else {
               bannerView3.isHidden = true
           }
       }
     func adViewDidReceiveAd(_ bannerView: GADBannerView) {
         //addBannerViewToView(bannerView)
         bannerView3.isHidden = false
         print("adreceived")
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.becomeFirstResponder()
        //setupBannerView()
        interstitial1 = GADInterstitial(adUnitID: "ca-app-pub-8233515273063706/7401150820")
        interstitial1.delegate = self
        let request = GADRequest()
        interstitial1.load(request)
        setupBannerViewOriginal()
        bannerView3.isHidden = true
        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
        nTitle.textAlignment = .center
        nTitle.font = .boldSystemFont(ofSize: 25)
        nTitle.textColor = #colorLiteral(red: 0.5811578631, green: 0.2669279277, blue: 0.7445558906, alpha: 1)
        nTitle.text = "New Memo"
        self.navigationItem.titleView = nTitle
        
        //saveButton = UIButton(type: UIButton.ButtonType.custom)
        saveButton.setImage(UIImage(named: "save.png"), for: .normal)
        saveButton.imageEdgeInsets = .init(top: 48, left: 48, bottom: 48, right: 48)
        saveButton.addTarget(self, action: #selector(saveMemo), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: saveButton)
        self.navigationItem.rightBarButtonItems = [rightBarButton]
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setImage(UIImage(named: "list.png"), for: .normal)
        cancelButton.imageEdgeInsets = .init(top: 48, left: 48, bottom: 48, right: 48)
        cancelButton.addTarget(self, action: #selector(cancelMemo), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
        
        //if let memo = editTarget {
        //            self.navigationItem.title = "Edit Memo"
        //            textView.text = memo.content
        //            originalMemoContent = memo.content
        //} else {
        self.navigationItem.title = "New Memo"
        textView.text = ""
        //}
        textView.delegate = self
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.textView.contentInset
                inset.bottom = height
                strongSelf.textView.contentInset = inset
                
                inset = strongSelf.textView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.textView.scrollIndicatorInsets = inset
            }
        })
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            var inset = strongSelf.textView.contentInset
            inset.bottom = 0
            strongSelf.textView.contentInset = inset
            
            inset = strongSelf.textView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.textView.scrollIndicatorInsets = inset
            
        })
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
        
    }
    
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to save?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
            self?.saveMemo(action)
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No", style: .cancel) {
            [weak self] (action) in
            self?.cancelMemo(action)
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
//    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
//        self.dismiss(animated: true, completion: nil)
//    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("dismiss")
        self.dismiss(animated: true, completion: nil)
    }
}


