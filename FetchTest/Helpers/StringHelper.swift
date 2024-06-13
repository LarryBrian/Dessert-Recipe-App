//
//  StringHelper.swift
//  FetchTest
//
//  Created by Brian King on 6/12/24.
//

import Foundation

extension String {
    func replacingLast(_ n: Int, with replacement: String) -> String {
        guard n <= self.count else {
            return replacement
        }
        let endIndex = self.index(self.endIndex, offsetBy: -n)
        return self[..<endIndex] + replacement
    }
}
