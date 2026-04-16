//
//  PrivacyWebView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI
import WebKit

struct HostedBrowseShell: View {
    let landingAddressLine: String
    var whenBrowseFails: () -> Void
    var whenBrowseStabilizes: (() -> Void)? = nil

    @State private var webView: WKWebView = WKWebView()
    @State private var canGoBack: Bool = false
    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        webView.goBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(canGoBack ? .white : .gray)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                    }
                    .disabled(!canGoBack)

                    Spacer()

                    Button(action: {
                        webView.reload()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                    }
                }
                .frame(height: 60)
                .background(Color.black)

                BrowsePortalRepresentable(
                    webView: webView,
                    landingAddressLine: landingAddressLine,
                    canGoBack: $canGoBack,
                    isLoading: $isLoading,
                    whenBrowseFails: whenBrowseFails,
                    whenBrowseStabilizes: whenBrowseStabilizes
                )
            }
            .ignoresSafeArea()
            .statusBar(hidden: true)

            if isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2.0)
                }
            }
        }
    }
}

// MARK: - UIViewRepresentable
struct BrowsePortalRepresentable: UIViewRepresentable {
    let webView: WKWebView
    let landingAddressLine: String
    @Binding var canGoBack: Bool
    @Binding var isLoading: Bool
    var whenBrowseFails: () -> Void
    var whenBrowseStabilizes: (() -> Void)?

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator

        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.backgroundColor = .black
        webView.isOpaque = false

        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.allowsBackForwardNavigationGestures = true

        if let url = URL(string: landingAddressLine) {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: BrowsePortalRepresentable
        private var failureCalled = false

        init(parent: BrowsePortalRepresentable) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if let httpResponse = navigationResponse.response as? HTTPURLResponse {
                if GuildFlowDefaultsStore.nucleus.rememberedLandingAddress == nil && !failureCalled {
                    if (400...599).contains(httpResponse.statusCode) {
                        failureCalled = true
                        GuildFlowDefaultsStore.nucleus.hasPresentedNativeHub = true
                        decisionHandler(.cancel)

                        DispatchQueue.main.async {
                            self.parent.whenBrowseFails()
                        }
                        return
                    }
                }
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                if ["mailto", "tel", "sms"].contains(url.scheme) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.canGoBack = webView.canGoBack
            parent.isLoading = false

            if GuildFlowDefaultsStore.nucleus.rememberedLandingAddress == nil {
                if let currentUrl = webView.url?.absoluteString {
                    GuildFlowDefaultsStore.nucleus.rememberedLandingAddress = currentUrl
                    GuildFlowDefaultsStore.nucleus.hasSuccessfulBrowseSession = true
                    DispatchQueue.main.async {
                        self.parent.whenBrowseStabilizes?()
                    }
                }
            } else {
                GuildFlowDefaultsStore.nucleus.hasSuccessfulBrowseSession = true
                DispatchQueue.main.async {
                    self.parent.whenBrowseStabilizes?()
                }
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false

            if GuildFlowDefaultsStore.nucleus.rememberedLandingAddress == nil && !failureCalled {
                failureCalled = true

                GuildFlowDefaultsStore.nucleus.hasPresentedNativeHub = true
                DispatchQueue.main.async {
                    self.parent.whenBrowseFails()
                }
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
