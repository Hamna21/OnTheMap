//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/22/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

public func performUIUpdatesOnMain(_ updates: @escaping() -> Void){
    DispatchQueue.main.async {
        updates()
    }
}
