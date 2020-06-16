
import UIKit
import GoogleMobileAds
//import FBAudienceNetwork


class DetailViewController: UIViewController, GADBannerViewDelegate {
    var memo: MemoEntity?
    //var bannerAdView: FBAdView!
    var bannerView: GADBannerView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd ccc hh:mma"
        return formatter
    }()
    
    func setupBannerView() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
        bannerView = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-8233515273063706/4250447722"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
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
    }
    
    @IBAction func shareMemo(_ sender: UIBarButtonItem) {
        guard let memo = memo?.content else { return }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let composeVC = segue.destination.children.first as? ComposeViewController {
            composeVC.editTarget = memo
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerView()
        //bannerAdView = FBAdView(placementID: "177353010371214_177911173648731", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
       // guard let rootView = UIApplication.shared.keyWindow else { return }
//        let bottomInset = rootView.safeAreaInsets.bottom
//        bannerAdView.frame = CGRect(x: 0.0, y: rootView.bounds.size.height
//            - bottomInset - toolBar.bounds.size.height - 50.0 , width: rootView.bounds.size.width, height: 50.0)
//        bannerAdView.delegate = self
//        bannerAdView.isHidden = false
//        self.view.addSubview(bannerAdView)
//        bannerAdView.loadAd()
        
        //toolBar.barTintColor = .systemPurple
        toolBar.alpha = 0.7
        listTableView.backgroundColor = .clear
        NotificationCenter.default.addObserver(forName: .memoDidEdit, object: nil, queue: .main) { (_) in
            self.listTableView.reloadData()
        }
    }
}
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = dateFormatter.string(for: memo?.date)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            let attrString = NSMutableAttributedString(string: cell.textLabel?.text ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            cell.textLabel?.attributedText = attrString
            return cell
        }
    }
    
    // Do any additional setup after loading the view.
}

