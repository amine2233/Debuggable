//
//  File.swift
//  
//
//  Created by Amine Bensalah on 16/03/2021.
//

import Foundation

extension Bundle {
    static let test = Bundle(for: PrivateClass.self)
}

private class PrivateClass {
    init() {}
}
