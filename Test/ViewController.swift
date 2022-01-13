//
//  ViewController.swift
//  Test
//
//  Created by Jan Dammshäuser on 13.01.22.
//

import UIKit
import OpusKit

class ViewController: UIViewController {

	private var didBecomeActiveObserver: AnyObject?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		OpusKit.shared.initialize()

		didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
			self?.readPasteboard()
		}
	}

	private func readPasteboard() {
		guard let (data, ext) = getPasteboardData(),
					let dat = OpusKit.shared.decodeData(data)
		else { return }

		do {
			let url = FileManager.default.temporaryDirectory.random(withExtension: ext)
			try dat.write(to: url)
		} catch {
			print(error)
		}
	}

	private func getPasteboardData() -> (Data, String)? {
		let format = "dyn.age80835h"
		guard UIPasteboard.general.contains(pasteboardTypes: [format]),
					let data = UIPasteboard.general.data(forPasteboardType: format) else { return nil }
		return (data, "ogg")
	}
}

extension URL {
	func random(withExtension ext: String) -> URL {
		appendingPathComponent("\(Int.random(in: 0...1_000)).\(ext)")
	}
}

