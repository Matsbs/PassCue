//
//  CuesViewController.h
//  PassCue
//
//  Created by Mats Sandvoll on 03.04.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuesViewController : UIViewController <UICollectionViewDataSource,  UICollectionViewDelegate>{
    UICollectionView *_collectionView;
}

@end
