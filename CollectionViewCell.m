//
//  CollectionViewCell.m
//  collectionView
//
//  Created by xulide on 15/5/6.
//  Copyright (c) 2015年 xulide. All rights reserved.
//
#import "CollectionViewCell.h"


@implementation CollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil];
        if(arrayOfViews.count < 1) {return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {return nil;}
        self = [arrayOfViews objectAtIndex:0] ;
    }
    NSLog(@"frame = %f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    return self;
}


//-(id)init
//{
//    self = [super init];
//    if(self)
//    {
//        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil];
//        if(arrayOfViews.count < 1) {return nil;}
//        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {return nil;}
//        self = [arrayOfViews objectAtIndex:0] ;
//    }
//    return self;
//}

/*
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    UITouch *touch= [touches anyObject];

    CGPoint touchPoint = [touch locationInView:self];

    if(SINGLE_TOUCH == touch.tapCount)
    {
       [self performSelector:@selector(handleSingleTouch:) withObject:[NSValue valueWithCGPoint:touchPoint] afterDelay:0.3f];
    
    }
    else if (DOUBLE_TOUCH == touch.tapCount)
    {
        
       [self handleDoubleTouch:[NSValue valueWithCGPoint:touchPoint]];
    }


}

-(void)handleSingleTouch:(NSValue *)pointValue
{
    return;
}


-(void)handleDoubleTouch:(NSValue *)pointValue
{
    return;
}
 */
@end
