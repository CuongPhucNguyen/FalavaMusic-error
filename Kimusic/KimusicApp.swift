import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


@main
struct KimusicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var views = SongListViewModel()
    @State var myMusicList: [MusicModel] = MusicSessionManager.shared.MusicTabManger
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(views)
                .onAppear{
                   

//                    signup(email: "tintin123k@gmail.com", password: "1234567", displayName: "tin", photoURL: "https://i.kym-cdn.com/photos/images/original/001/513/767/998.png")
                    login(email: "tintin123k@gmail.com", password: "1234567")
                    print(currentUser()?.email)
//                    var handle = Auth.auth().addStateDidChangeListener { auth, user in
//                        print(user?.email)
//                    }

                }
        }
    }
}



extension View{
    func applyBG()->some View{
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color("BackGround")
                    .ignoresSafeArea()
            }
    }
}
