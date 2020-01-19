import UIKit
import Firebase
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    static var appContainer = LocalhostAppDependencyContainer(environment: environment)
    private var applicationCoordinator: ApplicationCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        LHAuth.configure(for: .firebase)
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let config = LHUIConfiguration()
        config.configureUI()
        
        MSAppCenter.start("a1305a48-049b-4c1b-951f-b0e98c781d8a", withServices:[
            MSAnalytics.self,
            MSCrashes.self
        ])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.lhPurple
        let applicationCoordinator = AppDelegate.appContainer.makeApplicationCoordinator(window: window!)
        self.applicationCoordinator = applicationCoordinator
        self.applicationCoordinator!.start()
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerForPushNotifications()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // called when the app is coming to screen, e.g. after push notification open
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let hexString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("device token: \(deviceTokenString)")
        print("device token: \(hexString)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {}
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notifications sent on APNS
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message sent by FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            guard let userId = Auth.auth().currentUser?.uid else {
                return print("NO CURRENT USER")
            }
            let usersRef = Firestore.firestore().collection("users").document(userId)
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("DID RECEIVE REMOTE MESSAGE: \(remoteMessage.appData)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let deepLinkOption = DeepLinkOption.build(with: userInfo as [AnyHashable: Any])
        applicationCoordinator?.start(with: deepLinkOption)
        completionHandler()
    }
    
    // The callback to handle data message received via FCM - BACKGROUND / ClOSED
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    // This method will be called when app received push notifications - FOREGROUND
    // By not calling the completionHandler you suppress showing the notification
    // CHeck a) current VC b) current channel to see if its the one from the message
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {}
}

