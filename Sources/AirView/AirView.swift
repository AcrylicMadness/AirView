//
//  AirView.swift
//  AirTest
//
//  Created by Acrylic M. on 22.02.2024.
//

import Combine
import SwiftUI

private struct AirView<AirViewContent: View>: ViewModifier {
    
    // MARK: - Properties
    private var isScreenConnected: Binding<Bool>
    
    @ViewBuilder
    private var content: () -> AirViewContent
    
    @State
    private var additionalWindows: [UIWindow] = []
    
    // MARK: - Initialization
    init(isScreenConnected: Binding<Bool>, @ViewBuilder content: @escaping () -> AirViewContent) {
        self.isScreenConnected = isScreenConnected
        self.content = content
    }
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .onReceive(screenDidConnectPublisher, perform: screenDidConnect)
            .onReceive(screenDidDisconnectPublisher, perform: screenDidDisconnect)
    }
    
    // MARK: - Handling screen connection
    private var screenDidConnectPublisher: AnyPublisher<UIScreen, Never> {
      NotificationCenter.default
        .publisher(for: UIScreen.didConnectNotification)
        .compactMap { $0.object as? UIScreen }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    private var screenDidDisconnectPublisher: AnyPublisher<UIScreen, Never> {
      NotificationCenter.default
        .publisher(for: UIScreen.didDisconnectNotification)
        .compactMap { $0.object as? UIScreen }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    private func screenDidConnect(_ screen: UIScreen) {
        let window = UIWindow(frame: screen.bounds)
        
        window.windowScene = UIApplication.shared.connectedScenes.first { ($0 as? UIWindowScene)?.screen == screen } as? UIWindowScene
        
        let view = content()
        let controller = UIHostingController(rootView: view)
        window.rootViewController = controller
        window.isHidden = false
        additionalWindows.append(window)
        
        isScreenConnected.wrappedValue = true
    }
    
    private func screenDidDisconnect(_ screen: UIScreen) {
        additionalWindows.removeAll { $0.screen == screen }
        isScreenConnected.wrappedValue = false
    }
}

public extension View {
    
    /// Allows you to display a separate view when external AirPlay screen is connected
    /// - Parameters:
    ///   - isScreenConnected: A binding to a Boolean value that indicates if external screen is connected
    ///   - content: A closure that returns the content to be displayed on AirPlay screen
    func airView(isScreenConnected: Binding<Bool>, @ViewBuilder content: @escaping () -> some View) -> some View {
        modifier(AirView(isScreenConnected: isScreenConnected, content: content))
    }
}
