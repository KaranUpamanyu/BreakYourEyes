//
//  HoverButton.swift
//  BreakYourEyes
//
//  Created by Karan Upamanyu on 06/10/24.
//

import AppKit

class HoverButton: NSButton {
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        self.trackingAreas.forEach { self.removeTrackingArea($0) }
        
        let trackingArea = NSTrackingArea(
            rect: self.bounds,
            options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        self.addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        print("Mouse entered hover area")
        super.mouseEntered(with: event)
        
        self.attributedTitle = NSAttributedString(string: "Nah, I’ll skip", attributes: [
            .font: NSFont.systemFont(ofSize: 20),
            .foregroundColor: NSColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
        NSCursor.pointingHand.push()
    }

    override func mouseExited(with event: NSEvent) {
        print("Mouse exited hover area")
        NSCursor.arrow.set()
        super.mouseExited(with: event)
        
        self.attributedTitle = NSAttributedString(string: "Nah, I’ll skip", attributes: [
            .font: NSFont.systemFont(ofSize: 20),
            .foregroundColor: NSColor.white,
            .underlineStyle: 0
        ])
        
        NSCursor.pop()
    }
}
