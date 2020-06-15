
import UIKit
import GoogleMobileAds
import Firebase
//import FBAudienceNetwork

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithOpaqueBackground()
            //let colorLiteral = #colorLiteral(red: 0.8302105069, green: 0.964060843, blue: 1, alpha: 1)
            let colorLiteral = #colorLiteral(red: 1, green: 0.70462358, blue: 0.8701322675, alpha: 1)
            coloredAppearance.backgroundColor = colorLiteral
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemPurple]
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemPurple]
            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        } else {
            // Fallback on earlier versions
        }
        CoreDataManager.shared.setup(modelName: "UnicornMemo")
        CoreDataManager.shared.fetchMemo()
        //Google Admob
        FirebaseApp.configure()
        //DeviceInfo.createDeviceId()
        //DeviceInfo.getMemberArray()
         //Google Admob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        //FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

