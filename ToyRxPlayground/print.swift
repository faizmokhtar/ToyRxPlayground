//
//  print.swift
//  ToyRxPlayground
//
//  Created by AD0502 on 16/10/2020.
//

import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

public func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}
