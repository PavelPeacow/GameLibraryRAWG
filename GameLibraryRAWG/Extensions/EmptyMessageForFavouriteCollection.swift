//
//  EmptyMessageForFavouriteCollection.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 13.09.2022.
//

import Foundation
import UIKit

extension UICollectionView {

    func setEmptyMessageInCollectionView(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.preferredFont(forTextStyle: .headline)
       

        self.backgroundView = messageLabel;
    }

    func restoreCollectionViewBackground() {
        self.backgroundView = nil
    }
}
