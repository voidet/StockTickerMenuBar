//
//  TickerMenuController.swift
//  StockTicker
//
//  Created by Richard Sbresny on 5/18/18.
//  Copyright © 2018 Richard S. All rights reserved.
//

import Cocoa

class TickerMenuController: NSObject {
  
  @IBOutlet weak var statusMenu: NSMenu!
  @IBOutlet weak var stockPrice: NSMenuItem!
  
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let alphaAdvantageAPI = AlphaAdvantageAPI()
  
  override func awakeFromNib() {
    let icon = NSImage(named: NSImage.Name("statusIcon"))
    icon?.isTemplate = true // best for dark mode
    statusItem.image = icon
    statusItem.menu = statusMenu
  }
  
  @IBAction func updateClicked(_ sender: NSMenuItem) {
    alphaAdvantageAPI.fetchStocks(["APPL", "VTI", "VXUS"], completion: { stocks in
      self.statusItem.title = "\(stocks.first!.symbol) $\(stocks.first!.price)"
    })
  }
  
  @IBAction func quitClicked(_ sender: NSMenuItem) {
    NSApplication.shared.terminate(self)
  }


}
