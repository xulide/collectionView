//
//  ImageInstance.m
//  collectionView
//
//  Created by xulide on 15/5/9.
//  Copyright (c) 2015年 xulide. All rights reserved.
//

#import "CollectionViewCell.h"
#import "ConstantDefine.h"
#import "ImageInstance.h"
@interface ImageInstance()
@property (strong, nonatomic) NSCache *memCache;
@property (strong, nonatomic) NSMutableDictionary *collectionViewCellDictionary;
-(void)createImageViewCache:(NSNumber*)type rectSize:(CGRect)rect;
@end

const static int MINE_BITMAP_PIXEL = 16; // 每个图片的大小

@implementation ImageInstance

UIImage *imageParent;
NSMutableDictionary *dictionary;


-(id)init
{
    if ( self = [super init] )
    {
        imageParent = [UIImage imageNamed:@"BITMAP0.png"];
        
        NSLog(@"width =%f ,length=%f,scale=%f",imageParent.size.width,imageParent.size.height,imageParent.scale);
        
        dictionary = [[NSMutableDictionary alloc]init];
        _memCache = [NSCache new];
        _memCache.countLimit = totalCostLimit;
        _collectionViewCellDictionary = [[NSMutableDictionary alloc]init];
        
        for(mineType i = MINE_BLANK_HUMP ;i <= MINE_BLANK;i++)
        {
            CGRect rect =  CGRectMake(0, i*MINE_BITMAP_PIXEL, MINE_BITMAP_PIXEL, MINE_BITMAP_PIXEL);
            NSNumber * type = [NSNumber numberWithInt:(int)i];
            [dictionary setObject:[NSValue valueWithCGRect:rect] forKey: type];
            [self createImageViewCache:type rectSize:rect];
        }
    }
    return self;
}

-(void)createImageViewCache:(NSNumber*)type rectSize:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageParent CGImage], rect); //获得剪切区域B
    
    UIImage *subIma = [UIImage imageWithCGImage:imageRef]; // 把B转化成一张图片
    
    CGImageRelease(imageRef);
    
    CGFloat cost = subIma.size.height * subIma.size.width * subIma.scale * subIma.scale;
    [self.memCache setObject:subIma forKey:type cost:cost];
}

//-(void)createCollectionViewCellDictionary:(mineType) type
//{
//    for(mineType i = MINE_BLANK_HUMP ;i <= MINE_BLANK;i++)
//    {
//        CollectionViewCell CollectionViewCell= [[CollectionViewCell alloc]initWithFrame:CGRect(0,0,16,16)];
//        
//        _collectionViewCellDictionary
//    }
//    
//
//
//}

-(id) getImageFromMineType:(mineType) type
{
    UIImage *subIma = nil;
    
    subIma = [self.memCache objectForKey: [NSNumber numberWithInt:(int)type]];
    
    if(subIma == nil)
    {
        CGRect rect = [[dictionary objectForKey:[NSNumber numberWithInt:(int)type]] CGRectValue];
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([imageParent CGImage], rect); //获得剪切区域B
        
        subIma = [UIImage imageWithCGImage:imageRef]; // 把B转化成一张图片
        
        CGImageRelease(imageRef);
        
        CGFloat cost = subIma.size.height * subIma.size.width * subIma.scale * subIma.scale;
        [self.memCache setObject:subIma forKey:[NSNumber numberWithInt:(int)type] cost:cost];
        
        NSLog(@"subIma is nil  subIma is nilsubIma is nil subIma is nil ");
    }
    
    static CGRect rect ;
    rect = CGRectMake(0, 0, MINE_BITMAP_PIXEL, MINE_BITMAP_PIXEL);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    
    imageView.image = subIma;
    
    return imageView;
    
//        UIImageView *imageView = nil;
//    
//        imageView = [self.memCache objectForKey: [NSNumber numberWithInt:(int)type]];
//    
//        if(imageView == nil)
//        {
//            CGRect rect = [[dictionary objectForKey:[NSNumber numberWithInt:(int)type]] CGRectValue];
//    
//            CGImageRef imageRef = CGImageCreateWithImageInRect([imageParent CGImage], rect); //获得剪切区域B
//    
//            UIImage *subIma = [UIImage imageWithCGImage:imageRef]; // 把B转化成一张图片
//    
//            CGImageRelease(imageRef);
//            
//            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
//            
//            imageView.image = subIma;
//            
//            [self.memCache setObject:imageView forKey:[NSNumber numberWithInt:(int)type]];
//        }
    
//        return imageView;
}
@end
