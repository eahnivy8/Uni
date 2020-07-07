import UIKit
import StoreKit
import GoogleMobileAds

class ModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver, UIPopoverPresentationControllerDelegate, GADBannerViewDelegate {
    
    var bannerView4: GADBannerView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let productID = "com.sangwookahn.UnicornMemo.Ad_free"
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      let save = UserDefaults.standard
              if save.value(forKey: "Purchase") == nil {
                setupBannerView()
          } else {
              bannerView4.isHidden = true
          }
      }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        //addBannerViewToView(bannerView)
        bannerView4.isHidden = false
        print("adreceived")
    }
    func setupBannerView() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50)
        )
        bannerView4 = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView4)
        bannerView4.adUnitID = "ca-app-pub-8233515273063706/9349180407"
        bannerView4.rootViewController = self
        bannerView4.load(GADRequest())
        bannerView4.delegate = self
    }
    func setupBannerViewOriginal() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
        bannerView4 = GADBannerView(adSize: adSize)
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
//    func adViewDidReceiveAd(_bannerView: FBAdView) {
//        guard let rootView = UIApplication.shared.keyWindow else { return }
//        let bottomInset = rootView.safeAreaInsets.bottom
//        bannerAdView3.frame = CGRect(x: 0.0, y: rootView.bounds.size.height
//            - bottomInset - 100.0 , width: rootView.bounds.size.width, height: 50.0)
//        bannerAdView3.delegate = self
//        bannerAdView3.isHidden = false
//        self.view.addSubview(bannerAdView3)
//        bannerAdView3.loadAd()
//    }
//    override func viewWillAppear(_ animated: Bool){
//        let save = UserDefaults.standard
////        print(save.value(forKey: "Purchase"))
//        if save.value(forKey: "Purchase") == nil {
//            bannerAdView3 = FBAdView(placementID: "1440669492772192_1454568158048992", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
//            guard let rootView = UIApplication.shared.keyWindow else { return }
//            let bottomInset = rootView.safeAreaInsets.bottom
//            bannerAdView3.frame = CGRect(x: 0.0, y: rootView.bounds.size.height
//                - bottomInset - 100.0 , width: rootView.bounds.size.width, height: 50.0)
//            bannerAdView3.delegate = self
//            bannerAdView3.isHidden = false
//            self.view.addSubview(bannerAdView3)
//            bannerAdView3.loadAd()
//        } else {
//            bannerAdView3.isHidden = true
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupBannerView()
        //bannerView4.isHidden = true
        setupBannerViewOriginal()
        bannerView4.isHidden = true
        listTableView.delegate = self
        listTableView.dataSource = self
        SKPaymentQueue.default().add(self)
        
//        bannerAdView3 = FBAdView(placementID: "1440669492772192_1454568158048992", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        //        guard let rootView = UIApplication.shared.keyWindow else { return }
        //        print(rootView)
        //        let bottomInset = rootView.safeAreaInsets.bottom
        //        bannerAdView3.frame = CGRect(x: 0.0, y: rootView.bounds.size.height
        //            - bottomInset - 100.0 , width: rootView.bounds.size.width, height: 50.0)
        //        //bannerAdView.delegate = self
        //        bannerAdView3.isHidden = false
        //        self.view.addSubview(bannerAdView3)
        //        bannerAdView3.loadAd()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "Remove Ads($1.99)"
                cell.detailTextLabel?.text = "No more ads🦄"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath)
                cell.textLabel?.text = "Restore Purchase"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell", for: indexPath)
            cell.textLabel?.text = "Share this app"
            cell.detailTextLabel?.text = "with your loved ones🌈"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return nil
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("remove ads")
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                buyAdFree()
                listTableView.deselectRow(at: indexPath, animated: true)
            } else {
                //restore in-app purchase
                SKPaymentQueue.default().restoreCompletedTransactions()
                listTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        else {
            let memo = """
            Unicorn Memo
            Unicorn Memo is unique and super convenient to use.
            https://itunes.apple.com/app/id1510682779
            """
            let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
            present(vc, animated: true, completion: nil)
            if let popoverController = vc.popoverPresentationController, let indexPath = self.listTableView.indexPathForSelectedRow, let cell = self.listTableView.cellForRow(at: indexPath) {
                popoverController.permittedArrowDirections = .left
                popoverController.sourceView = self.listTableView
                popoverController.sourceRect = CGRect(x: cell.frame.width / 7, y: cell.frame.minY + 22, width: 1, height: 1)
            }
            listTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - In-App Purchase Methods
    // get purchase info.
    func buyAdFree() {
        if SKPaymentQueue.canMakePayments() {
            //can make payments
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please enable in-app purchase in your settings", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
            //Can't make payments
            print("User can't make payments")
            
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            //user payment successful
            case SKPaymentTransactionState.purchased:
                print("Transaction successful")
                buyAdFree()
                SKPaymentQueue.default().finishTransaction(transaction)
                let save = UserDefaults.standard
                save.set(true, forKey: "Purchase")
                bannerView4.isHidden = true
                break
            case .failed:
                //payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                buyAdFree()
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            default:
                break
            }
            
        }
        
    }
}



