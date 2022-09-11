//
//  ConstraintPriority.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 11.09.2022.
//

import Foundation
import UIKit

extension NSLayoutConstraint
{
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint
    {
        self.priority = priority
        return self
    }
}
