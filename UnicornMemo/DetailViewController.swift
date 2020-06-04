

import UIKit
import FBAudienceNetwork


class DetailViewController: UIViewController, FBAdViewDelegate {
    var memo: MemoEntity?
    var bannerAdView: FBAdView!
    //@IBOutlet weak var bannnerView: GADBannerView!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd ccc hh:mma"
        //formatter.dateStyle = .short
        //formatter.timeStyle = .short
        return formatter
    }()
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
    
    @IBAction func shareMemo(_ sender: UIBarButtonItem) {
        guard let memo = memo?.content else { return }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
    }
    //share function added
//    @objc func share(_ sender: Any) {
//        guard let memo = memo?.content else { return }
//        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
//        present(vc, animated: true, completion: nil)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let composeVC = segue.destination.children.first as? ComposeViewController {
            composeVC.editTarget = memo
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    bannerAdView = FBAdView(placementID: "177353010371214_177911173648731", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
    bannerAdView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 150 , width: UIScreen.main.bounds.size.width, height: 50.0)
    bannerAdView.delegate = self
    bannerAdView.isHidden = false
    self.view.addSubview(bannerAdView)
    bannerAdView.loadAd()
//        bannnerView.adUnitID = "ca-app-pub-8233515273063706/8283189944"
//        bannnerView.rootViewController = self
//        bannnerView.load(GADRequest())
        toolBar.barTintColor = .cyan
        toolBar.alpha = 0.7
        listTableView.backgroundColor = .clear
        NotificationCenter.default.addObserver(forName: .memoDidEdit, object: nil, queue: .main) { (_) in
            self.listTableView.reloadData()
        }
//        let shareButton = UIButton(type: .custom)
//        shareButton.setImage(UIImage(named: "share.png"), for: .normal)
//        shareButton.imageEdgeInsets = .init(top: 28, left: 28, bottom: 28, right: 28)
//        shareButton.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
//        let rightBarButton = UIBarButtonItem(customView: shareButton)
//        self.navigationItem.rightBarButtonItem = rightBarButton
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
            return cell
        }
    }
    
    // Do any additional setup after loading the view.
}

