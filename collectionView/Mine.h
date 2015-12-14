//
//  Mine.h
//  collectionView
//
//  Created by xulide on 15/5/9.
//  Copyright (c) 2015年 xulide. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum mineType{
    MINE_INVALID = -1,
    MINE_BLANK_HUMP = 0,//0
    MINE_FLAG, //1
    MINE_UNKNOWN_HUMP,//2
    MINE_THUNDER_RED,//3
    MINE_THUNDER_ERROR,//4
    MINE_THUNDER,//5
    MINE_UNKNOWN,//6
    MINE_EIGHT,//7
    MINE_SEVEN,//8
    MINE_SIX,//9
    MINE_FIVE,//10
    MINE_FOUR,//11
    MINE_THREE,//12
    MINE_TWO,//13
    MINE_ONE,//14
    MINE_BLANK//15
}mineType;

const static int MINE_NUM_TOTAL = 400;
const static int MINE_NUM_ROW = 20;
const static int MINE_NUM_COLUMN = 20;
const static int MINE_INTEGER_FLAG = /*0xFFFFFFFF*/15;

typedef struct{
    NSInteger rowIndex;
    NSInteger columnIndex;
}MineIndex;

@interface Mine : NSObject
{
    /*存储实际的雷区位置*/
    NSMutableArray *mineRealArray;
}
-(void)setMineArea;
-(void)printmineRealArray;
@property(nonatomic,strong)NSMutableArray *IndexPathArray;
/*最终显示在ui mine*/
@property(nonatomic,strong)NSMutableArray *mineDrawArray;

/*被用户标记成雷区*/
@property(nonatomic,strong)NSMutableSet *mineFlagSet;

-(void)singleHitIndex:(NSInteger)index;
-(void)doubleHitIndex:(NSInteger)index;

-(NSMutableArray *)getMineDrawArray;
-(NSNumber *)getObjectFromMineDrawArray:(NSInteger)index;
-(void)fillCaculate:(NSMutableDictionary *)caculateAreadictionary fillQueue:(NSMutableArray*)queue row:(NSInteger)rowInteger column:(NSInteger)columnInteger;
+(Mine *)sharedInstance;
@end
