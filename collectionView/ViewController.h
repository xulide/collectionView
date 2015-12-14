//
//  ViewController.h
//  collectionView
//
//  Created by xulide on 15/5/3.
//  Copyright (c) 2015年 xulide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,weak)  IBOutlet UICollectionView * collectionView;
@property(nonatomic,weak)  IBOutlet UILabel * label;

@end

