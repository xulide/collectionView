//
//  ManageMemento.h
//  collectionView
//
//  Created by xulide on 15/6/8.
//  Copyright (c) 2015年 xulide. All rights reserved.
//
@class Memento;
#import <Foundation/Foundation.h>

@interface ManageMemento : NSObject
-(Memento *)popMemento;
-(void)pushMemento:(Memento *)memento;
@end
