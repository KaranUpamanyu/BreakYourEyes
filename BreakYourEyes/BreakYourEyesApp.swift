//
//  BreakYourEyesApp.swift
//  BreakYourEyes
//
//  Created by Karan Upamanyu on 05/10/24.
//

import SwiftUI
import AppKit
import Cocoa

@main
struct BreakYourEyesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView() // Just a placeholder, no UI needed
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var overlayWindow: NSPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "🔴 𝐵𝓎𝑒"
            button.action = #selector(toggleReminder)
            button.target = self
        }
    }
    
    @objc func toggleReminder() {
        if timer == nil {
            startReminder()
        } else {
            stopReminder()
        }
    }
    
    func startReminder() {
        statusItem.button?.title = "🟢 𝐵𝓎𝑒"
        // Timer to trigger overlay every 20 minutes
        timer = Timer.scheduledTimer(timeInterval: 1200 /* seconds */, target: self, selector: #selector(showOverlay), userInfo: nil, repeats: true)
    }
    
    func stopReminder() {
        statusItem.button?.title = "🔴 𝐵𝓎𝑒"
        timer?.invalidate()
        timer = nil
    }
    
    @objc func showOverlay() {
        if (overlayWindow == nil) {
            createOverlayWindow()
        }
        
        //show the window
        overlayWindow?.makeKeyAndOrderFront(nil)
        overlayWindow?.alphaValue = 0.0
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5 /* seconds */
            overlayWindow?.animator().alphaValue = 1.0
        }
        
        // Timer for when the overlay is showed
        Timer.scheduledTimer(timeInterval: 20 /* seconds */, target: self, selector: #selector(hideOverlay), userInfo: nil, repeats: false)
    }
    
    @objc func hideOverlay() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3 /* seconds */
            overlayWindow?.animator().alphaValue = 0.0
        } completionHandler: {
            self.overlayWindow?.orderOut(nil)
        }
    }
    
    func createOverlayWindow() {
        let screenSize = NSScreen.main?.frame ?? .zero
        
        overlayWindow = NSPanel(contentRect: screenSize, styleMask: [], backing: .buffered, defer: false)
        overlayWindow?.level = .floating
        overlayWindow?.isMovableByWindowBackground = true
        overlayWindow?.styleMask = [.borderless, .fullSizeContentView, .nonactivatingPanel]
        overlayWindow?.hidesOnDeactivate = false
        overlayWindow?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        overlayWindow?.backgroundColor = NSColor.black.withAlphaComponent(0.8)
        overlayWindow?.isOpaque = false
        
        overlayWindow?.ignoresMouseEvents = false
        
        let contentView = NSView(frame: screenSize)
        overlayWindow?.contentView = contentView
        
        let breakLabel = NSTextField(labelWithString: "Time to break your eyes")
        breakLabel.font = NSFont.boldSystemFont(ofSize: 80)
        breakLabel.textColor = .white
        breakLabel.alignment = .center
        breakLabel.isBezeled = false
        breakLabel.isEditable = false
        breakLabel.backgroundColor = .clear
        
        let skipButton = HoverButton(title: "Nah, I’ll skip", target: self, action: #selector(hideOverlay))
        skipButton.font = NSFont.systemFont(ofSize: 18)
        skipButton.isBordered = false
        skipButton.contentTintColor = .white
        skipButton.alignment = .center
        skipButton.wantsLayer = true
        skipButton.layer?.masksToBounds = false
        
        let stackView = NSStackView(views: [breakLabel, skipButton])
        stackView.orientation = .vertical
        stackView.spacing = 140 // Spacing between the text and the button
        stackView.alignment = .centerX // Center alignment
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
