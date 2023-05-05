//
//  HTTPURLResponseExtension.swift
//  
//
//  Authors: Jeluchu
//  Creation: 5/5/23
//

import Foundation

extension HTTPURLResponse {
     func isResponseOK() -> Bool {
      return (200...299).contains(self.statusCode)
     }
}
