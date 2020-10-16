//
//  print.swift
//  ToyRxPlayground
//
//  Created by AD0502 on 16/10/2020.
//

import Foundation

public func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}
