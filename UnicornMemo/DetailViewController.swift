import UIKit
import GoogleMobileAds

extension NSNotification.Name {
    //    static let memoDidInsert = NSNotification.Name(rawValue: "MemoDidInsert")
    static let memoDidEdit = NSNotification.Name(rawValue: "MemoDidEdit")
}

class DetailViewController: UIViewController, GADBannerViewDelegate, UITextViewDelegate {
    //var editBarButton: UIBarButtonItem!
    let editButton = UIButton(type: .custom)
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolBar: UIToolbar!
    var bannerView2: GADBannerView!
    //var bannerAdView2: FBAdView!
    var memo: MemoEntity?
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      let save = UserDefaults.standard
              if save.value(forKey: "Purchase") == nil {
                setupBannerView()
          } else {
              bannerView2.isHidden = true
          }
      }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        //addBannerViewToView(bannerView)
        bannerView2.isHidden = false
        print("adreceived")
    }
    func setupBannerView() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
        bannerView2 = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView2)
        bannerView2.adUnitID = "ca-app-pub-8233515273063706/4250447722"
        bannerView2.rootViewController = self
        bannerView2.load(GADRequest())
        bannerView2.delegate = self
        
    }
    func setupBannerViewOriginal() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
        bannerView2 = GADBannerView(adSize: adSize)
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
                                constant: -(toolBar.bounds.size.height)),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
    }
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to delete this memo?", preferredStyle:.alert)
        let ok = UIAlertAction(title: "Yes", style: .default) { [weak self] (_) in
            if let memo = self?.memo {
                CoreDataManager.shared.deleteMemo(entity: memo)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
        //        if let memo = memo {
        //            CoreDataManager.shared.deleteMemo(entity: memo)
        //            self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        editButton.setImage(UIImage(named: "done.png"), for: .normal)
        editButton.imageEdgeInsets = .init(top: 41, left: 41, bottom: 41, right: 41)
        editButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: editButton)
//        let editBarButton = UIBarButtonItem(image: UIImage(named: "done.png"), style: .plain, target: self, action: #selector(done))
//        let editBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItems = [rightBarButton, shareButton]
    }
    @objc func done() {
        memo?.content = textView.text
        CoreDataManager.shared.saveContext()
        NotificationCenter.default.post(name: .memoDidEdit, object: nil)
        textView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = shareButton
        self.navigationItem.rightBarButtonItems = [shareButton]
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        guard let memo = memo?.content else { return }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupBannerView()
        setupBannerViewOriginal()
        bannerView2.isHidden = true
        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
        nTitle.textAlignment = .center
        nTitle.font = .boldSystemFont(ofSize: 25)
        nTitle.textColor = #colorLiteral(red: 0.5811578631, green: 0.2669279277, blue: 0.7445558906, alpha: 1)
        nTitle.text = "Memo View"
        self.navigationItem.titleView = nTitle
        //bannerAdView = FBAdView(placementID: "177353010371214_177911173648731", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        // guard let rootView = UIApplication.shared.keyWindow else { return }
        textView.delegate = self
        dateLabel.text = dateFormatter.string(for: memo?.date)
        textView.text = memo?.content
        toolBar.barTintColor = .systemPurple
        toolBar.alpha = 0.7
        
    }
}














//
//import UIKit
//import GoogleMobileAds
////import FBAudienceNetwork
//
//
//class DetailViewController: UIViewController, GADBannerViewDelegate, UITextViewDelegate {
//    var memo: MemoEntity?
//    //var bannerAdView: FBAdView!
//    var bannerView: GADBannerView!
//    
//    @IBOutlet weak var toolBar: UIToolbar!
//    
//    lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY/MM/dd ccc hh:mma"
//        return formatter
//    }()
//    
//    func setupBannerView() {
//        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
//        bannerView = GADBannerView(adSize: adSize)
//        addBannerViewToView(bannerView)
//        bannerView.adUnitID = "ca-app-pub-8233515273063706/4250447722"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        bannerView.delegate = self
//        
//    }
//    func addBannerViewToView(_ bannerView: GADBannerView) {
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        view.addConstraints(
//            [NSLayoutConstraint(item: bannerView,
//                                attribute: .bottom,
//                                relatedBy: .equal,
//                                toItem: view.safeAreaLayoutGuide,
//                                attribute: .bottom,
//                                multiplier: 1,
//                                constant: -(toolBar.bounds.size.height)),
//             NSLayoutConstraint(item: bannerView,
//                                attribute: .centerX,
//                                relatedBy: .equal,
//                                toItem: view,
//                                attribute: .centerX,
//                                multiplier: 1,
//                                constant: 0)
//        ])
//    }
//    @IBAction func deleteMemo(_ sender: Any) {
//        let alert = UIAlertController(title: "Alert", message: "Do you want to delete this memo?", preferredStyle:.alert)
//        let ok = UIAlertAction(title: "Yes", style: .default) { [weak self] (_) in
//            if let memo = self?.memo {
//                CoreDataManager.shared.deleteMemo(entity: memo)
//                self?.navigationController?.popViewController(animated: true)
//            }
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(ok)
//        alert.addAction(cancel)
//        self.present(alert, animated: true)
//    }
//    
//    @IBAction func shareMemo(_ sender: UIBarButtonItem) {
//        guard let memo = memo?.content else { return }
//        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
//        vc.popoverPresentationController?.barButtonItem = sender
//        present(vc, animated: true, completion: nil)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let composeVC = segue.destination.children.first as? ComposeViewController {
//            composeVC.editTarget = memo
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupBannerView()
//        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
//        nTitle.textAlignment = .center
//        nTitle.font = .boldSystemFont(ofSize: 25)
//        nTitle.textColor = #colorLiteral(red: 0.5811578631, green: 0.2669279277, blue: 0.7445558906, alpha: 1)
//        nTitle.text = "Memo View"
//        self.navigationItem.titleView = nTitle
//        //bannerAdView = FBAdView(placementID: "177353010371214_177911173648731", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
//       // guard let rootView = UIApplication.shared.keyWindow else { return }
////        let bottomInset = rootView.safeAreaInsets.bottom
////        bannerAdView.frame = CGRect(x: 0.0, y: rootView.bounds.size.height
////            - bottomInset - toolBar.bounds.size.height - 50.0 , width: rootView.bounds.size.width, height: 50.0)
////        bannerAdView.delegate = self
////        bannerAdView.isHidden = false
////        self.view.addSubview(bannerAdView)
////        bannerAdView.loadAd()
//        
//        //toolBar.barTintColor = .systemPurple
//        toolBar.alpha = 0.7
//        //listTableView.backgroundColor = .clear
//        //NotificationCenter.default.addObserver(forName: .memoDidEdit, object: nil, queue: .main) { (_) in
//        //    self.listTableView.reloadData()
//        }
//    }
//
////extension DetailViewController: UITableViewDataSource {
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return 2
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        if indexPath.row == 0 {
////            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
////            cell.textLabel?.text = dateFormatter.string(for: memo?.date)
////            return cell
////        } else {
////            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
////            cell.textLabel?.text = memo?.content
////            let attrString = NSMutableAttributedString(string: cell.textLabel?.text ?? "")
////            let paragraphStyle = NSMutableParagraphStyle()
////            paragraphStyle.lineSpacing = 5
////            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
////            cell.textLabel?.attributedText = attrString
////            return cell
////        }
////    }
////
//    // Do any additional setup after loading the view.
////}
//
