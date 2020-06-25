
import UIKit
import MessageUI
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var unicornImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    var bannerView1: GADBannerView!
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView1.isHidden = false
    }    //var bannerAdView: FBAdView!
    let editButton = UIButton(type: UIButton.ButtonType.custom)
    let settingButton = UIButton(type: UIButton.ButtonType.custom)
    //    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    var buttonActive = true
    @objc func settingButtonAction(_ sender: UIBarButtonItem) {
        guard let modalVC = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") else { return }
        modalVC.modalTransitionStyle = .crossDissolve
        present(modalVC, animated: true, completion: nil)
    }
    @objc func editButtonAction(_ sender: UIButton) {
        if buttonActive {
            listTableView.setEditing(true, animated: true)
            editButton.setImage(UIImage(named: "done.png"), for: .normal)
            unicornImage.isHidden = true
        } else {
            listTableView.setEditing(false, animated: true)
            editButton.setImage(UIImage(named:
                "edit.png"), for: .normal)
            unicornImage.isHidden = false
        }
        buttonActive = !buttonActive
    }
    func setupBannerView() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50)
        )
        bannerView1 = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView1)
        bannerView1.adUnitID = "ca-app-pub-8233515273063706/4373736656"
        bannerView1.rootViewController = self
        bannerView1.load(GADRequest())
        bannerView1.delegate = self
        
    }
    func setupBannerViewOriginal() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
        bannerView1 = GADBannerView(adSize: adSize)
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
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd EEE"
        return formatter
    }()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.memo = CoreDataManager.shared.list[indexPath.row]
            }
        }
    }
    func sendEmail(with data: String) {
        guard MFMailComposeViewController.canSendMail() else { return }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject("Mail")
        composer.setMessageBody(data, isHTML: false)
        present(composer, animated: true, completion: nil)
    }
    func sendMessage(with data: String) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = self
        composer.body = data
        present(composer, animated: true, completion: nil)
    }
    func delete(at indexPath: IndexPath) {
        let target = CoreDataManager.shared.list[indexPath.row]
        CoreDataManager.shared.context.delete(target)
        CoreDataManager.shared.saveContext()
        CoreDataManager.shared.list.remove(at: indexPath.row)
        listTableView.deleteRows(at: [indexPath], with: .automatic)
    }

        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil {
            setupBannerView()
        } else {
            bannerView1.isHidden = true
        }
        
        unicornImage.isUserInteractionEnabled = true
        guard let rootView = UIApplication.shared.keyWindow else { return }
        unicornImage.bounds = CGRect(x: rootView.bounds.size.width/2 , y: rootView.bounds.size.height - 150, width: 170, height: 170)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat,.autoreverse, .curveLinear,
                                                                .allowUserInteraction, .beginFromCurrentState], animations: {
                                                                    self.unicornImage.center  = CGPoint(x: self.unicornImage.bounds.origin.x, y: self.unicornImage.bounds.origin.y - 32.0)})
        print("viewwillappear")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil {
            setupBannerView()
        } else {
            bannerView1.isHidden = true
        }
        unicornImage.isUserInteractionEnabled = true
        guard let rootView = UIApplication.shared.keyWindow else { return }
        unicornImage.bounds = CGRect(x: rootView.bounds.size.width/2, y: rootView.bounds.size.height - 150, width: 170, height: 170)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse, .curveLinear,
                                                                .allowUserInteraction, .allowAnimatedContent, .beginFromCurrentState], animations: {
                                                                    self.unicornImage.center  = CGPoint(x: self.unicornImage.bounds.origin.x, y: self.unicornImage.bounds.origin.y - 10.0)})
//        { _ in
//                                                                        self.unicornImage.center  = CGPoint(x: self.unicornImage.bounds.origin.x, y: self.unicornImage.bounds.origin.y - 20.0)
//
//        }
//        print("viewdidappear")
    }
    
    @objc func applicationEnterInBackground() {
        //view.layer.removeAllAnimations()
        unicornImage.layer.removeAllAnimations()
        print("background")
    }
    
    @objc func applicationEnterInForground() {
        guard let rootView = UIApplication.shared.keyWindow else { return }
        unicornImage.bounds = CGRect(x: rootView.bounds.size.width/2 , y: rootView.bounds.size.height - 150, width: 170, height: 170)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat,.autoreverse, .curveLinear, .allowUserInteraction, .allowAnimatedContent, .beginFromCurrentState], animations: {
            self.unicornImage.center  = CGPoint(x: self.unicornImage.bounds.origin.x, y: self.unicornImage.bounds.origin.y - 27.0)
            print("foreground")
            //            self.unicornImage.layer.layoutIfNeeded()
        })
//        { _ in
////            UIView.animate(withDuration: 0.8) {
////                     self.unicornImage.center  = CGPoint(x: self.unicornImage.bounds.origin.x, y: self.unicornImage.bounds.origin.y - 40.0)
//            self.unicornImage.center  = CGPoint(x: self.unicornImage.bounds.origin.x, y: self.unicornImage.bounds.origin.y - 45.0)
//                      //self.unicornImage.layer.layoutIfNeeded()
//        }
//        print("foreground")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerViewOriginal()
        bannerView1.isHidden = true
        unicornImage.isUserInteractionEnabled = true
        guard let rootView = UIApplication.shared.keyWindow else { return }
        unicornImage.bounds = CGRect(x: rootView.bounds.size.width/2 , y: rootView.bounds.size.height - 150, width: 170, height: 170)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat,.autoreverse,.curveLinear,
                                                                .allowUserInteraction, .beginFromCurrentState], animations: {
                                                                    self.unicornImage.center  = CGPoint(x: self.unicornImage.bounds.origin.x, y: self.unicornImage.bounds.origin.y - 22.0)})
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterInForground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterInBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        print("viewdidload")
        //setupBannerView()
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        editButton.setImage(UIImage(named: "edit.png"), for: .normal)
        editButton.imageEdgeInsets = .init(top: 43, left: 43, bottom: 43, right: 43)
        editButton.addTarget(self, action: #selector(self.editButtonAction(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: editButton)
        settingButton.setImage(UIImage(named: "rainbow.png"), for: .normal)
        settingButton.imageEdgeInsets = .init(top: 41, left: 41, bottom: 41, right: 41)
        settingButton.addTarget(self, action: #selector(self.settingButtonAction(_:)), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: settingButton)
        self.navigationItem.rightBarButtonItems = [rightBarButton]
        self.navigationItem.leftBarButtonItem = leftBarButton
        //self.navigationItem.leftBarButtonItem = rightBarButton2
        
        listTableView.backgroundColor = .clear
        CoreDataManager.shared.fetchMemo()
        
        NotificationCenter.default.addObserver(forName: .memoDidInsert, object: nil, queue: .main) { [weak self] _ in
            let index = IndexPath(row: 0, section: 0)
            self?.listTableView.insertRows(at: [index], with: .automatic)
        }
        NotificationCenter.default.addObserver(forName: .memoDidDelete, object: nil, queue: .main) { [weak self] (_) in
            self?.listTableView.reloadData()
        }
        NotificationCenter.default.addObserver(forName: .memoDidEdit, object: nil, queue: .main) { [weak self] (_) in
            self?.listTableView.reloadData()
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreDataManager.shared.list.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       // if indexPath.row < CoreDataManager.shared.list.count {
        cell.textLabel?.text = CoreDataManager.shared.list[indexPath.row].content
        cell.detailTextLabel?.text = dateFormatter.string(for: CoreDataManager.shared.list[indexPath.row].date)
        return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Memo relocation function.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = CoreDataManager.shared.list[sourceIndexPath.row]
        CoreDataManager.shared.list.remove(at: sourceIndexPath.row)
        CoreDataManager.shared.list.insert(movedObject, at: destinationIndexPath.row)
        
        var postionStart = 0
        
        for item in CoreDataManager.shared.list {
            item.positionInTable = Int32(postionStart)
            postionStart += 1
        }
        CoreDataManager.shared.saveContext()
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let emailAction = UITableViewRowAction(style: .default, title: "email") { [weak self] (action, indexPath) in
            if let data = CoreDataManager.shared.list[indexPath.row].content {
                self?.sendEmail(with: data)
            }
        }
        emailAction.backgroundColor = .systemGreen
        
        let messageAction = UITableViewRowAction(style: .normal, title: "Text") { [weak self] (action, indexPath) in
            if let data = CoreDataManager.shared.list[indexPath.row].content {
                self?.sendMessage(with: data)
            }
        }
        messageAction.backgroundColor = .systemTeal
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self](action, indexPath) in
            self?.delete(at: indexPath)
        }
        return [deleteAction, messageAction, emailAction]
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        CoreDataManager.shared.list = CoreDataManager.shared.fetch(keyword: keyword)
        self.listTableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        CoreDataManager.shared.fetchMemo()
        self.searchBar.resignFirstResponder()
        self.searchBar.text = nil
        self.listTableView.reloadData()
    }
}


