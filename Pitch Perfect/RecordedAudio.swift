//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Kelvin Lee on 3/31/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    // designated initializer
    init(usingFilePathUrl: NSURL, withTitle: String) {
        
        self.filePathUrl = usingFilePathUrl
        self.title = withTitle
        
        // have to call super
        super.init()
    }
    
}
