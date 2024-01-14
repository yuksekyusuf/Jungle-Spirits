//
//  SwiftUIView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 13.01.2024.
//

import SwiftUI
import Pow

struct IrisView: View {
    @State var sealed = false
    @State var showLevelMap = false
    var body: some View {
            ZStack {
                if sealed {
                    Image("Menu Screen")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.movingParts.iris(blurRadius: 10))

                    if showLevelMap {
                        Image("mapsTabBackground")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }



                }
            }
            .autotoggle($sealed, with: .spring(dampingFraction: 1))

    }

}
//
struct GlowExample: View {
    @State var isFormValid = false

    var body: some View {
        ZStack {
            Color.clear

            JungleButtonView(text: "ENTER THE JUNGLE", width: 300, height: 50)
                .conditionalEffect(.repeat(.glow(color: .blue, radius: 50), every: 1.5  ), condition: isFormValid)
//            .conditionalEffect(
//                    .repeat(
//                        .glow(color: .blue, radius: 50),
//                        every: 1.5
//                    ),
//                    condition: canContinue
//                )
            .disabled(!isFormValid)
            .animation(.default, value: isFormValid)
//            .contentShape(Rectangle())
            .onTapGesture {
                isFormValid.toggle()
            }
        }
    }

}


struct GlowExample_Previews: PreviewProvider {
    static var previews: some View {
        GlowExample()
    }
}
//
//
//
//
//public extension View {
//    /// Applies the given change effect to this view while a condition is `true`.
//    ///
//    /// - Parameters:
//    ///   - effect: The effect to apply.
//    ///   - condition: A boolean that indicates whether the effect is active.
//    ///
//    /// - Returns: A view that applies the effect to this view when `isActive` is `true`.
//    @ViewBuilder
//    func conditionalEffect(_ effect: AnyConditionalEffect, condition: Bool) -> some View {
//        switch effect.guts {
//        case .continuous(let effect):
//            modifier(ContinuousEffectModifier(effect: effect, isActive: condition))
//                .environment(\.isConditionalEffect, true)
//        case .repeating(let effect, let interval):
//            modifier(RepeatingChangeEffectModifier(effect: effect, interval: interval, isActive: condition))
//                .environment(\.isConditionalEffect, true)
//        }
//    }
//}
//
//public struct AnyConditionalEffect {
//    internal enum Guts {
//        case continuous(AnyContinuousEffect)
//        case repeating(AnyChangeEffect, TimeInterval)
//    }
//
//    internal var guts: Guts
//
//    private init(guts: Guts) {
//        self.guts = guts
//    }
//
//    internal static func continuous(_ effect: AnyContinuousEffect) -> AnyConditionalEffect {
//        AnyConditionalEffect(guts: .continuous(effect))
//    }
//
//    /// Repeats a change effect at the specified interval while a condition is true.
//    ///
//    /// - Parameters:
//    ///   - effect: The change effect to repeat.
//    ///   - interval: The number of seconds between each change effect.
//    public static func `repeat`(_ effect: AnyChangeEffect, every interval: TimeInterval) -> AnyConditionalEffect {
//        AnyConditionalEffect(guts: .repeating(effect, interval))
//    }
//
//    /// Repeats a change effect at the specified interval while a condition is true.
//    ///
//    /// - Parameters:
//    ///   - effect: The change effect to repeat.
//    ///   - interval: The duration between each change effect.
//    @available(iOS 16.0, *)
//    @available(macOS 13.0, *)
//    public static func `repeat`(_ effect: AnyChangeEffect, every interval: Duration) -> AnyConditionalEffect {
//        AnyConditionalEffect(guts: .repeating(effect, interval.timeInterval))
//    }
//}
//
//private struct ContinuousEffectModifier: ViewModifier {
//
//    var effect: AnyContinuousEffect
//
//    var isActive: Bool
//
//    @State
//    private var changeCount: Int = 0
//
//    @State
//    private var startDate: Date = .distantPast
//
//    func body(content: Content) -> some View {
//        content
//            .modifier(effect.viewModifier(isActive))
//    }
//}
//
//private struct RepeatingChangeEffectModifier: ViewModifier {
//    private final class RepeatingTimer: ObservableObject {
//        @Published
//        var count: Int = 0
//
//        var timer: Timer? {
//            willSet {
//                timer?.invalidate()
//            }
//        }
//
//        init() {}
//
//        func resume(interval: TimeInterval, delay: TimeInterval = 0) {
//            if delay != 0 {
//                timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] t in
//                    self?.resume(interval: interval)
//                }
//            } else {
//                count += 1
//
//                reschedule(interval: interval)
//            }
//        }
//
//        private func reschedule(interval: TimeInterval) {
//            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] t in
//                self?.resume(interval: interval)
//            }
//        }
//
//        func pause() {
//            timer = nil
//        }
//    }
//
//    var effect: AnyChangeEffect
//
//    var interval: TimeInterval
//
//    @StateObject
//    private var timer = RepeatingTimer()
//
//    private var isEnabled: Bool
//
//    init(effect: AnyChangeEffect, interval: TimeInterval, isActive: Bool) {
//        self.effect = effect
//        self.interval = clamp(1 / 15, interval, .infinity)
//        self.isEnabled = isActive && interval > 0
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .modifier(effect.viewModifier(changeCount: timer.count))
//            .onAppear {
//                if isEnabled {
//                    timer.resume(interval: interval, delay: effect.delay)
//                }
//            }
//            .onChange(of: isEnabled) { isEnabled in
//                if isEnabled {
//                    timer.resume(interval: interval, delay: effect.delay)
//                } else {
//                    timer.pause()
//                }
//            }
//            .onChange(of: interval) { interval in
//                if isEnabled {
//                    timer.resume(interval: interval, delay: effect.delay)
//                }
//            }
//    }
//}
//
//internal extension EnvironmentValues {
//    private struct IsConditionalEffectKey: EnvironmentKey {
//        static var defaultValue: Bool = false
//    }
//
//    var isConditionalEffect: Bool {
//        get { self[IsConditionalEffectKey.self] }
//        set { self[IsConditionalEffectKey.self] = newValue }
//    }
//}
//
//#if os(iOS) && DEBUG
//struct WhileEffectPreview_Previews: PreviewProvider {
//    private struct Preview: View {
//        @State
//        private var isEnabled: Bool = false
//
//        var body: some View {
//            GroupBox("iOS 15") {
//                VStack {
//                    Toggle("Enabled", isOn: $isEnabled)
//
//                    Button {
//
//                    } label: {
//                        Label("Answer", systemImage: "phone.fill")
//                    }
//                    .tint(.green)
//                    .buttonStyle(.borderedProminent)
//                    .controlSize(.large)
//                    .conditionalEffect(.repeat(.shake(rate: .fast), every: 1), condition: isEnabled)
//                }
//            }
//            .padding()
//        }
//    }
//
//    @available(iOS 16.0, *)
//    private struct Preview16: View {
//        @State
//        private var isEnabled: Bool = false
//
//        var body: some View {
//            GroupBox("iOS 16") {
//                VStack {
//                    Toggle("Enabled", isOn: $isEnabled)
//
//                    Button {
//
//                    } label: {
//                        Label("Answer", systemImage: "phone.fill")
//                    }
//                    .tint(.green)
//                    .buttonStyle(.borderedProminent)
//                    .controlSize(.large)
//                    .conditionalEffect(.repeat(.wiggle(rate: .fast), every: .seconds(1.5)), condition: isEnabled)
//
//                    Button {
//
//                    } label: {
//                        Label("Alert", systemImage: "light.beacon.max.fill")
//                    }
//                    .tint(.red)
//                    .buttonStyle(.borderedProminent)
//                    .controlSize(.large)
//                    .conditionalEffect(.repeat(.glow(color: .red, radius: 50), every: .seconds(1)), condition: isEnabled)
//
//                    Button {
//
//                    } label: {
//                        Label("Press", systemImage: "hand.raised.fingers.spread.fill")
//                    }
//                    .tint(.blue)
//                    .buttonStyle(.borderedProminent)
//                    .controlSize(.large)
//                    .conditionalEffect(.pushDown, condition: isEnabled)
//
//                    Button {
//
//                    } label: {
//                        Label("Burn", systemImage: "opticaldisc")
//                    }
//                    .tint(.gray)
//                    .buttonStyle(.borderedProminent)
//                    .controlSize(.large)
//                    .conditionalEffect(.smoke, condition: isEnabled)
//                }
//            }
//            .padding()
//        }
//    }
//
//    static var previews: some View {
//        if #available(iOS 16.0, *) {
//            Preview16()
//                .preferredColorScheme(.dark)
//        } else {
//            Preview()
//        }
//    }
//}
//#endif
//
//public struct AnyChangeEffect {
//    private var modifier: (Int) -> AnyViewModifier
//
//    private var animation: Animation?
//
//    internal var cooldown: Double
//
//    internal var delay: Double = 0
//
//    fileprivate init(modifier: @escaping (Int) -> AnyViewModifier, animation: Animation?, cooldown: Double) {
//        self.modifier = modifier
//        self.animation = animation
//        self.cooldown = cooldown
//    }
//
//    internal func viewModifier(changeCount: Int) -> some ViewModifier {
//        modifier(changeCount)
//            .animation(animation)
//    }
//
//    public func delay(_ delay: Double) -> Self {
//        var copy = self
//        copy.delay = delay
//
//        return copy
//    }
//}
//
//extension AnyChangeEffect {
//    static func animation<Modifier: ViewModifier & Animatable>(_ makeModifier: @escaping (Int) -> Modifier, animation: Animation? = .default, cooldown: Double = 0.33) -> AnyChangeEffect {
//        AnyChangeEffect(
//            modifier: { change in
//                makeModifier(change)
//                    .eraseToAnyViewModifier()
//            },
//            animation: animation,
//            cooldown: cooldown
//        )
//    }
//
//    static func simulation<Modifier: ViewModifier & Simulative>(_ makeModifier: @escaping (Int) -> Modifier) -> AnyChangeEffect {
//        AnyChangeEffect(modifier: { change in
//            makeModifier(change).eraseToAnyViewModifier()
//        }, animation: nil, cooldown: 0.0)
//    }
//}
