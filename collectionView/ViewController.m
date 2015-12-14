//
//  ViewController.m
//  collectionView
//
//  Created by xulide on 15/5/3.
//  Copyright (c) 2015年 xulide. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "Mine.h"
#import "ImageInstance.h"
#import "ConstantDefine.h"
@interface ViewController ()
-(void)updateDrawArea:(NSNotification*)notification;
@property(nonatomic,strong) Mine * mine;
@property(nonatomic,strong) ImageInstance * imageInstance;
@property(nonatomic,weak) NSMutableArray * mineDrawArray;


@end

//static int const SINGLE_TOUCH = 1 ;
//static int const DOUBLE_TOUCH = 2 ;

@implementation ViewController
{

}
static int tapCount = 0;

- (void)viewDidLoad {
    NSLog(@"%@",@"viewDidLoad enter");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"simpleCell"];
    self.mine = [Mine sharedInstance];
    self.imageInstance = [[ImageInstance alloc]init];
    self.mineDrawArray = [self.mine getMineDrawArray];
    
    //添加update 消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateDrawArea:) name:(NSString*)notificationName object:self.mine];
   
    [self.mine setMineArea];
    [self.mine printmineRealArray];
    NSLog(@"%@",@"viewDidLoad leave");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if(nil == self.view.window)
    {
        self.collectionView = nil;
        self.mine = nil;
        self.imageInstance = nil;
        self.mineDrawArray = nil;
       
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.

}

//定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%@",@"numberOfItemsInSection enter");
    
    NSLog(@"%@",@"numberOfItemsInSection leave");
    return self.mineDrawArray.count;
}
 
//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"%@",@"numberOfSectionsInCollectionView");
    return sectionNum;
}
 
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"simpleCell";
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSNumber *number = self.mineDrawArray[indexPath.item];
    
    cell.backgroundView = [self.imageInstance getImageFromMineType:(mineType)(number.integerValue)];
    
    
    
    return cell;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(16, 16);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",@"didSelectItemAtIndexPath enter");
    /*
    tapCount++;
    
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    

    if (DOUBLE_TOUCH == tapCount)
    {
         [self performSelector:@selector(handleDoubleTouch:) withObject:indexPath afterDelay:0.5f];
    }
    else if(SINGLE_TOUCH == tapCount)
    {
        [self performSelector:@selector(handleSingleTouch:) withObject:indexPath afterDelay:0.5f];
    }
    else
    {
    
    }
     */
    [self.mine  singleHitIndex:indexPath.item];
//    NSLog(@"%@",@"didSelectItemAtIndexPath leave");
    return;

}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)handleSingleTouch:(NSIndexPath *)indexPath
{
    NSLog(@"%@",@"handleSingleTouch enter");
    tapCount = 0;

    NSLog(@"%ld", indexPath.item);
    [self.mine  singleHitIndex:indexPath.item];

    NSLog(@"%@",@"handleSingleTouch leave");
    return;
}


-(void)handleDoubleTouch:(NSIndexPath *)indexPath
{
    NSLog(@"%@",@"handleDoubleTouch enter");
    tapCount = 0;
    [self.mine  doubleHitIndex:indexPath.item];
    NSLog(@"%@",@"handleDoubleTouch leave");
    return;
}


-(void)updateDrawArea:(NSNotification*)notification
{
    NSLog(@"%@",@"updateDrawArea enter");

   [self.collectionView reloadItemsAtIndexPaths:(NSArray*)self.mine.IndexPathArray];
  
    NSLog(@"%@",@"updateDrawArea leave");
    return;
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
