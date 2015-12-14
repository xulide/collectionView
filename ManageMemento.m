//
//  ManageMemento.m
//  collectionView
//
//  Created by xulide on 15/6/8.
//  Copyright (c) 2015年 xulide. All rights reserved.
//

#import "ManageMemento.h"

@implementation ManageMemento
{
    NSMutableArray * mutableArray;
}

-(id)init
{
    if(self = [super init])
    {
        mutableArray = [[NSMutableArray alloc] init];
    
    }
    return self;
}

-(Memento *)popMemento
{
    Memento * memento = (Memento *)mutableArray.lastObject;
    
    [ mutableArray removeLastObject];
    
    return memento;
}

-(void)pushMemento:(Memento *)memento
{
    [mutableArray addObject:memento];
}
@end
