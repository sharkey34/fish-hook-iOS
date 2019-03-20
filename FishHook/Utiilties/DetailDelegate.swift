//
//  DetailDelegate.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/20/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation


protocol detailDelegate: AnyObject {
    func pushDetail(cell: Int, indentifier: String)
}
