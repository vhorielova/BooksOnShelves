import SwiftUI

struct ContentView: View {
    @StateObject var viewModel =  ContentViewViewModel()
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty{
            MainTabbedView(userId: viewModel.currentUserId)
        } else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
