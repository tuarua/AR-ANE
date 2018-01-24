//
//  PermissionEvent.swift
//  ARANE_FW
//
//  Created by Eoin Landy on 24/01/2018.
//  Copyright © 2018 Tua Rua Ltd. All rights reserved.
//

import Foundation

public struct PermissionEvent {
    public static let NOT_DETERMINED = 0
    public static let RESTRICTED = 1
    public static let DENIED = 2
    public static let ALLOWED = 3
    public static let ON_STATUS:String = "Permission.OnStatus"
}
