//
//  DynamicCollectionView.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 03.09.2022.
//

import UIKit

class DynamicCollectionView: UICollectionView {

    //MARK: Dynamic height of CollectionView
    override func layoutSubviews() {
      super.layoutSubviews()
      if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
          self.invalidateIntrinsicContentSize()
       }
    }

     override var intrinsicContentSize: CGSize {
      return collectionViewLayout.collectionViewContentSize
     }

}
