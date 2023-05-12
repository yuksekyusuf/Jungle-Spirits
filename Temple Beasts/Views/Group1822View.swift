import SwiftUI
import UIKit

struct TempleBeastsView: UIViewRepresentable {
//    private(set) var preferredMaxLayoutWidth: CGFloat = 0
    
    
    func makeUIView(context: UIViewRepresentableContext<TempleBeastsView>) -> UILabel {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 227, height: 105)
        view.backgroundColor = .white
        
        view.font = UIFont(name: "TrickyJimmy-Regular", size: 81.43)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.96
        // Line height: 55 pt
        view.textAlignment = .center
        view.attributedText = NSMutableAttributedString(string: "Temple\nBeasts", attributes: [NSAttributedString.Key.kern: 1.8, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return view
    }
    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<TempleBeastsView>) { }
    
    
    
    
}
struct ContentView1 : View {
    var body: some View {
        HStack {
            TempleBeastsView()
        }
    }
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
