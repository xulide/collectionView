//
//  Memento.m
//  collectionView
//
//  Created by xulide on 15/6/8.
//  Copyright (c) 2015年 xulide. All rights reserved.
//

#import "Memento.h"

@implementation Memento 
-(id)init
{
    if(self = [super init])
    {
        self.mementoMutableDictionary = nil;
    }
    return self;
}
@end
