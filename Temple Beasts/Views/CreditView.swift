//
//  CreditView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 19.09.2023.
//

import SwiftUI
import SwiftUIIntrospect

struct CreditView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var appLanguageManager: AppLanguageManager

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
//    @State private var scrollOffset: Int = 0
    @State private var autoScrolling = false
    @State private var scrollAmount: CGFloat = 0
    @State private var scrollTarget: String? = nil
    @State private var contentOffset: CGPoint = .zero

    @Binding var isPresent: Bool
    
    var designer: String {
        appLanguageManager.localizedStringForKey("DESIGNER", language: appLanguageManager.currentLanguage)
    }
    
    var developer: String {
        appLanguageManager.localizedStringForKey("DEVELOPER", language: appLanguageManager.currentLanguage)
    }
    private var overlayView: some View {
        ZStack{
            
            ScrollViewReader { proxy in
                
//                ScrollableView(self.$contentOffset, animationDuration: 6.0, showsScrollIndicator: false, axis: .vertical) {
////                ScrollView(.vertical, showsIndicators: false) {
//                    LazyVStack {
//                        Color.clear.frame(height: 1).id(1)
//
//                        Image("CreditLogo")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 270, height: 168)
//                            .padding(.top, 48)
////                            .id(1)
//                        Image("CreditLine")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 164, height: 48)
//                            .padding(.top, 10)
//                     
//
//                        VStack(spacing: 0) {
//                            Text("YASIR")
//                                .font(Font.custom("TempleGemsRegular", size: 28))
//                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
//                                .padding(.top, 20)
//
//                            Text("DESIGNER")
//                                .font(Font.custom("TempleGemsRegular", size: 23))
//                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
//                                .offset(y: -10)
//                            Button {
//                                openURL(URL(string: "https://twitter.com/yasirbugra")!)
//                            } label: {
//                                Image("YasirButton")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .offset(y: -10)
//                                    .id(2)
//
//                            }
//
//                            VStack(spacing: 0) {
//                                Text("YUSUF")
//                                    .font(Font.custom("TempleGemsRegular", size: 28))
//                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
//                                    .padding(.top, 32)
//                                Text("DEVELOPER")
//                                    .font(Font.custom("TempleGemsRegular", size: 23))
//                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
//                                    .offset(y: -10)
//                                Button {
//                                    openURL(URL(string: "https://twitter.com/ay_yuksek")!)
//                                } label: {
//                                    Image("YusufButton")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .offset(y: -10)
//                                }
//
//                            }
//                            .offset(y: -32)
//                            Text("MADE IN NYC . 2023")
//                                .font(Font.custom("TempleGemsRegular", size: 18))
//                                .multilineTextAlignment(.center)
//                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))                             .frame(width: 211, alignment: .center)
//                                .offset(y: -24)
//                                .id(3)
//                        }
//                        .frame(width: 168)
//                        Color.clear.frame(height: 1).id("end")
//                    }
//                    .frame(width: 270)
//                    .onAppear {
//                            self.contentOffset = CGPoint(x: 0, y: (400))
//                    }
//                }
//
//                .background {
//                    Image("CreditBackground")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 284, height: 302)
//                }
              
//                .onReceive(timer, perform: { _ in
//                    if autoScrolling {
//                        if scrollAmount < 4 {
//                            scrollAmount += 0.02
//                            print("scroll increased: ", scrollAmount)
//
//                        }
//                    }
//                    
//                })
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        autoScrolling = true
//                        while scrollAmount < 15 {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                
//                            }
//                            withAnimation(.linear(duration: 1.0).delay(1.0)) {
//                                self.scrollAmount += 1
//                            }
//                        }
//
//                    }
//                    
//                }
//                .onChange(of: autoScrolling) { new in
//                    if new == true {
//                        while scrollAmount < 15 {
//                            withAnimation(.linear(duration: 1)) {
//                                scrollAmount += 1
//                                print(scrollAmount)
//                            }
//                        }
//                        
//                    }
//                }
            
//                .onChange(of: scrollAmount) { new in
//                    print("New scroll amount", new)
//                    withAnimation(.linear(duration: 1.5)) {
//                        proxy.scrollTo(Int(new), anchor: .bottom)
//                        print("New proxy)")
//                    }
//                }
             
//                .onChange(of: scrollPosition) { newPosition in
//                    withAnimation(.linear(duration: 0.5)) { // Smooth and slow animation
//                        proxy.scrollTo(Int(newPosition), anchor: .bottom)
//                    }
//                }
//                .onReceive(timer) { _ in
//                    if autoScrolling {
//                        scrollPosition += 0.25 // Very small increment for smooth scrolling
//                        //                                if scrollPosition > 3 { // Adjust based on your content size
//                        //                                    scrollPosition = 1 // Reset or stop scrolling
//                        //                                }
//                    }
//                }
//                .onReceive(timer) { _ in
//                    if autoScrolling {
//                        scrollOffset = min(scrollOffset + 1, CGFloat.leastNonzeroMagnitude)
//                        withAnimation(.easeOut(duration: 1.5)) {
//                            proxy.scrollTo(3, anchor: .bottom) // Assuming the last item has an ID of 3
//                        }
////                        scrollOffset += 1
////                        withAnimation(.linear(duration: 0.15)) {
////                            proxy.scrollTo(scrollOffset)
////                        }
//                    }
//                }
//                .onReceive(timer) { _ in
//                                withAnimation {
//                                    proxy.scrollTo("end", anchor: .bottom)
//                                }
//                            }
//                .onLongPressGesture {
//                    timer.upstream.connect().cancel()
//
//                }
////                .onTapGesture {
////                    timer.upstream.connect().cancel()
////
////                }
            }
            
        }
        
    }
    var body: some View {
        VStack {
            ZStack {
                overlayView
                .frame(width: 284, height: 302)
                .gesture(DragGesture().onChanged({ _ in
                                stopAutoScrolling()
                            }))
                            .onTapGesture {
                                stopAutoScrolling()
                            }
                            .onLongPressGesture {
                                stopAutoScrolling()
                            }
                .shadow(color: .black.opacity(0.45), radius: 8, x: 0, y: 10)
                Button {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.isPresent.toggle()
                    }
                } label: {
                    Image("CreditButton")
                        .resizable()
                        .scaledToFill()
                    
                }
                .frame(width: 44, height: 44)
                .offset(x: 138, y: -138)
                
            }
            
        }
        
        .transition(.scale)
        .background(
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 1, green: 0.74, blue: 0.83), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.41, green: 0.33, blue: 0.88), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 1, y: 0),
                    endPoint: UnitPoint(x: 0, y: 1)
                )
                    .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
                
                    
            }
                .frame(width: 307, height: 326)
            
        )
        
        .onAppear {
            // Start auto-scrolling after a 1-second delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                autoScrolling = true
            }
        }
        
      
        .onDisappear {
            // Stop auto-scrolling and cleanup when the view disappears
            stopAutoScrolling()
        }
    }
    private func stopAutoScrolling() {
        autoScrolling = false
        timer.upstream.connect().cancel()
    }
}

//struct CreditView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var present = true
//        CreditView(isPresent: $present)
//    }
//}



//struct ScrollableView<Content: View>: UIViewControllerRepresentable, Equatable {
//
//    // MARK: - Coordinator
//    final class Coordinator: NSObject, UIScrollViewDelegate {
//        
//        // MARK: - Properties
//        private let scrollView: UIScrollView
//        var offset: Binding<CGPoint>
//
//        // MARK: - Init
//        init(_ scrollView: UIScrollView, offset: Binding<CGPoint>) {
//            self.scrollView          = scrollView
//            self.offset              = offset
//            super.init()
//            self.scrollView.delegate = self
//        }
//        
//        // MARK: - UIScrollViewDelegate
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            DispatchQueue.main.async {
//                self.offset.wrappedValue = scrollView.contentOffset
//            }
//        }
//    }
//    
//    // MARK: - Type
//    typealias UIViewControllerType = UIScrollViewController<Content>
//    
//    // MARK: - Properties
//    var offset: Binding<CGPoint>
//    var animationDuration: TimeInterval
//    var showsScrollIndicator: Bool
//    var axis: Axis
//    var content: () -> Content
//    var onScale: ((CGFloat)->Void)?
//    var disableScroll: Bool
//    var forceRefresh: Bool
//    var stopScrolling: Binding<Bool>
//    private let scrollViewController: UIViewControllerType
//
//    // MARK: - Init
//    init(_ offset: Binding<CGPoint>, animationDuration: TimeInterval, showsScrollIndicator: Bool = true, axis: Axis = .vertical, onScale: ((CGFloat)->Void)? = nil, disableScroll: Bool = false, forceRefresh: Bool = false, stopScrolling: Binding<Bool> = .constant(false),  @ViewBuilder content: @escaping () -> Content) {
//        self.offset               = offset
//        self.onScale              = onScale
//        self.animationDuration    = animationDuration
//        self.content              = content
//        self.showsScrollIndicator = showsScrollIndicator
//        self.axis                 = axis
//        self.disableScroll        = disableScroll
//        self.forceRefresh         = forceRefresh
//        self.stopScrolling        = stopScrolling
//        self.scrollViewController = UIScrollViewController(rootView: self.content(), offset: self.offset, axis: self.axis, onScale: self.onScale)
//    }
//    
//    // MARK: - Updates
//    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
//        self.scrollViewController
//    }
//
//    func updateUIViewController(_ viewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {
//        
//        viewController.scrollView.showsVerticalScrollIndicator   = self.showsScrollIndicator
//        viewController.scrollView.showsHorizontalScrollIndicator = self.showsScrollIndicator
//        viewController.updateContent(self.content)
//
//        let duration: TimeInterval                = self.duration(viewController)
//        let newValue: CGPoint                     = self.offset.wrappedValue
//        viewController.scrollView.isScrollEnabled = !self.disableScroll
//        
//        if self.stopScrolling.wrappedValue {
//            viewController.scrollView.setContentOffset(viewController.scrollView.contentOffset, animated:false)
//            return
//        }
//        
//        guard duration != .zero else {
//            viewController.scrollView.contentOffset = newValue
//            return
//        }
//        
//        UIView.animate(withDuration: duration, delay: 1, options: [.allowUserInteraction, .curveEaseInOut, .beginFromCurrentState], animations: {
//            viewController.scrollView.contentOffset = newValue
//        }, completion: nil)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self.scrollViewController.scrollView, offset: self.offset)
//    }
//    
//    //Calcaulte max offset
//    private func newContentOffset(_ viewController: UIViewControllerType, newValue: CGPoint) -> CGPoint {
//        
//        let maxOffsetViewFrame: CGRect = viewController.view.frame
//        let maxOffsetFrame: CGRect     = viewController.hostingController.view.frame
//        let maxOffsetX: CGFloat        = maxOffsetFrame.maxX - maxOffsetViewFrame.maxX
//        let maxOffsetY: CGFloat        = maxOffsetFrame.maxY - maxOffsetViewFrame.maxY
//        
//        return CGPoint(x: min(newValue.x, maxOffsetX), y: min(newValue.y, maxOffsetY))
//    }
//    
//    //Calculate animation speed
//    private func duration(_ viewController: UIViewControllerType) -> TimeInterval {
//        
//        var diff: CGFloat = 0
//        
//        switch axis {
//            case .horizontal:
//                diff = abs(viewController.scrollView.contentOffset.x - self.offset.wrappedValue.x)
//            default:
//                diff = abs(viewController.scrollView.contentOffset.y - self.offset.wrappedValue.y)
//        }
//        
//        if diff == 0 {
//            return .zero
//        }
//        
//        let percentageMoved = diff / UIScreen.main.bounds.height
//        
//        return self.animationDuration * min(max(TimeInterval(percentageMoved), 0.25), 1)
//    }
//    
//    // MARK: - Equatable
//    static func == (lhs: ScrollableView, rhs: ScrollableView) -> Bool {
//        return !lhs.forceRefresh && lhs.forceRefresh == rhs.forceRefresh
//    }
//}
//
//final class UIScrollViewController<Content: View> : UIViewController, ObservableObject {
//
//    // MARK: - Properties
//    var offset: Binding<CGPoint>
//    var onScale: ((CGFloat)->Void)?
//    let hostingController: UIHostingController<Content>
//    private let axis: Axis
//    lazy var scrollView: UIScrollView = {
//        
//        let scrollView                                       = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.canCancelContentTouches                   = true
//        scrollView.delaysContentTouches                      = true
//        scrollView.scrollsToTop                              = false
//        scrollView.backgroundColor                           = .clear
//        
//        if self.onScale != nil {
//            scrollView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.onGesture)))
//        }
//        
//        return scrollView
//    }()
//    
//    @objc func onGesture(gesture: UIPinchGestureRecognizer) {
//        self.onScale?(gesture.scale)
//    }
//
//    // MARK: - Init
//    init(rootView: Content, offset: Binding<CGPoint>, axis: Axis, onScale: ((CGFloat)->Void)?) {
//        self.offset                                 = offset
//        self.hostingController                      = UIHostingController<Content>(rootView: rootView)
//        self.hostingController.view.backgroundColor = .clear
//        self.axis                                   = axis
//        self.onScale                                = onScale
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    // MARK: - Update
//    func updateContent(_ content: () -> Content) {
//        
//        self.hostingController.rootView = content()
//        self.scrollView.addSubview(self.hostingController.view)
//        
//        var contentSize: CGSize = self.hostingController.view.intrinsicContentSize
//        
//        switch axis {
//            case .vertical:
//                contentSize.width = self.scrollView.frame.width
//            case .horizontal:
//                contentSize.height = self.scrollView.frame.height
//        }
//        
//        self.hostingController.view.frame.size = contentSize
//        self.scrollView.contentSize            = contentSize
//        self.view.updateConstraintsIfNeeded()
//        self.view.layoutIfNeeded()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(self.scrollView)
//        self.createConstraints()
//        self.view.setNeedsUpdateConstraints()
//        self.view.updateConstraintsIfNeeded()
//        self.view.layoutIfNeeded()
//    }
//    
//    // MARK: - Constraints
//    fileprivate func createConstraints() {
//        NSLayoutConstraint.activate([
//            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
//    }
//}
