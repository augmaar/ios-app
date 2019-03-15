//
//  Piece.swift
//  Augma
//
//  Created by Chase Carnaroli on 3/13/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import Foundation
import Parse

struct Piece {
    let id: String
    let title: String
    let tags: [String]
    let price: String
    let image: UIImage
    let seller: PFUser
}
