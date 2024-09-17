//
//  AutoEquatable.swift
//  QueroSerMBTests
//
//  Created by Guilherme Prata Costa on 16/09/24.
//

import Foundation

public protocol AutoEquatable: Equatable { }

public extension AutoEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        var lhsDump = String()
        dump(lhs, to: &lhsDump)

        var rhsDump = String()
        dump(rhs, to: &rhsDump)

        return rhsDump == lhsDump
    }
}
