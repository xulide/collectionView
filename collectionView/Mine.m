//
//  Mine.m
//  collectionView
//
//  Created by xulide on 15/5/9.
//  Copyright (c) 2015年 xulide. All rights reserved.
//
#import "Memento.h"
#import "Mine.h"
#import "ConstantDefine.h"
#import <CoreGraphics/CGGeometry.h>
#import <UIkit/UIGeometry.h>
#import <UIkit/UICollectionView.h>
//#import  <Foundation/NSValue.h>

@interface Mine()
-(void)notificateUpdate;
-(void)printmineRealArray;
+(NSMutableArray *)items2IndexPaths:(NSArray *)itemArray;
-( void)updateMineDrawArray:(NSMutableDictionary *)updateDictionary;
+(mineType)mineRealArea2mineDrawArea:(NSInteger)mineRealArea;
-(void)replaceMineDrawWithDictionary :(NSMutableDictionary *)updateDictionary;
@property(nonatomic,strong) dispatch_queue_t concurrent_queue_mineflagset;
@property(nonatomic,strong) dispatch_queue_t concurrent_queue_minedrawarray;
@property(nonatomic,strong) dispatch_queue_t serial_queue_caculatemine;

@property(nonatomic,strong) NSObject * minedrawarraySysnObject ;
@end

@implementation Mine
{
    
}

const static NSInteger blankInMineRealArea = 0;

+(Mine *)sharedInstance
{
    static dispatch_once_t once;
    static id instance = nil;
    dispatch_once(&once,^{
        instance = [Mine new];
    });
    return instance;
}


-(id)init
{
    if ( self = [super init] )
    {
        _mineDrawArray = [[NSMutableArray alloc] init];
        self.mineFlagSet = [[NSMutableSet alloc]init];
        
        for(int i = 0 ;i< MINE_NUM_TOTAL ;i++)
        {
            /*雷区初始化成 MINE_BLANK_HUMP*/
            [_mineDrawArray addObject :[[NSNumber alloc ]initWithInt: (int)MINE_BLANK_HUMP]];
        
        }
        
        _concurrent_queue_mineflagset = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        //_concurrent_queue_minedrawarray = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        _minedrawarraySysnObject = [NSObject new];
        _serial_queue_caculatemine = dispatch_queue_create("caculatemine", NULL);
       
       
        
        
    }
    return self;
}

/*布雷*/
-(void)setMineArea
{
    NSLog(@"%@",@"setMineArea enter");
    /*设置雷区*/
    mineRealArray = [[NSMutableArray alloc]initWithCapacity:MINE_NUM_ROW];
    
    for(NSInteger i = 0; i < MINE_NUM_ROW;i++)
    {
        NSMutableArray *mineArrayColumn = [[NSMutableArray alloc]initWithCapacity:MINE_NUM_COLUMN];
        for(NSInteger j =0 ;j< MINE_NUM_COLUMN;j++)
        {
            int rand = arc4random() % 10;
            
            // rand :0  mineType : MINE_BLANK;
            // rand :1  mineType : MINE_ONE;
            // rand :2  mineType : MINE_TWO;
            // ......
            // rand :9  mineType : MINE_THUNDER;
            
            mineType  mineTypeInstance;
            if(9 == rand)
            {
                mineTypeInstance = (NSInteger)MINE_INTEGER_FLAG;
            }
            else
            {
                mineTypeInstance = (NSInteger)0;
            }
            
            [mineArrayColumn  addObject: [NSNumber numberWithInteger:mineTypeInstance]];
            
        }
        [mineRealArray addObject:mineArrayColumn];
    }
    
    
    for(NSInteger i = 0; i < MINE_NUM_ROW;i++)
    {
        for(NSInteger j =0 ;j< MINE_NUM_COLUMN;j++)
        {
            NSNumber *num = [[mineRealArray objectAtIndex:i]objectAtIndex:j];
            
            NSInteger integer = num.integerValue;
            
            if((NSInteger)MINE_INTEGER_FLAG == integer)
            {
                [self caculateRow: i caculateColumn:j];
                 //printf("i=%ld  j=%ld\r\n",i,j);
            }
        }
    }
    
    /*设置数字区域*/
     NSLog(@"%@",@"setMineArea leave");
    
}


-(BOOL) isValidRow:(NSInteger)Row isValidColumn:(NSInteger)Column
{
    if(!((Row >= 0) && (Row < MINE_NUM_ROW)))
    {
        return NO;
    }
    
    if(!((Column >= 0) && (Column < MINE_NUM_COLUMN)))
    {
        return NO;
    }
    
    return YES;
}

-(void) caculateRow:(NSInteger)rowInteger caculateColumn:(NSInteger)columnInteger
{
    
    for(NSInteger i = rowInteger -1;i <= rowInteger+1;i++)
    {
       for(NSInteger j = columnInteger -1;j <= columnInteger+1;j++)
       {
           if ([ self isValidRow:i isValidColumn:j] != NO)
           {
                if(!((i == rowInteger) && (j == columnInteger)))
                {
                    NSInteger num =  [[[mineRealArray objectAtIndex: i] objectAtIndex:j] integerValue];
                    
                    if((NSInteger)MINE_INTEGER_FLAG != num)
                    {
                        num = num+1;

                        NSNumber *number = [[NSNumber alloc]initWithInteger:(NSInteger)num];

                        [[mineRealArray objectAtIndex: i] replaceObjectAtIndex:j withObject:number];
                    }
                }
           }

       }
    
    }
}

-(mineType) numToMineType:(NSNumber *)num
{
    mineType  mineTypeNum = MINE_INVALID;
    NSInteger integer = [num  integerValue];
    if(( integer <= (NSInteger)8) || (integer >= (NSInteger)0))
    {
        mineTypeNum = (mineType)((NSInteger)MINE_BLANK - integer);
    }
    else if(integer == (NSInteger)MINE_INTEGER_FLAG)
    {
        mineTypeNum = MINE_THUNDER;
    }
    else
    {
        mineTypeNum = MINE_INVALID;
    }
    
    return mineTypeNum;
}

+(void) index2RowAndColumn:(NSInteger)index row:(NSNumber **)rowParam column:(NSNumber **)columnParam
{
    NSInteger row = index / MINE_NUM_COLUMN;
    NSInteger column = index % MINE_NUM_COLUMN;
    
    *rowParam = [[NSNumber alloc] initWithInteger:row];
    *columnParam = [[NSNumber alloc] initWithInteger:column];
}

+(void) rowAndColumn2Index:(NSNumber **)index row:(NSInteger)rowParam column:(NSInteger)columnParam
{
    NSInteger integer = rowParam* MINE_NUM_COLUMN + columnParam;
    *index = [[NSNumber alloc] initWithInteger:integer];
}

-(void) caclulateMineAreaIndex:(NSInteger)index
{
    @autoreleasepool {
        NSNumber *row = [[NSNumber alloc] initWithInteger:0];
        NSNumber *column = [[NSNumber alloc] initWithInteger:0];
        
        [[self class] index2RowAndColumn:index row:&row column:&column];
        dispatch_async(_serial_queue_caculatemine,^{
            [self caclulateMineAreaRow: row.integerValue Column:column.integerValue];
            dispatch_async(dispatch_get_main_queue(),^{
            [self notificateUpdate];
            });
         
        });
    }
    
}

-(void) caclulateMineAreaRow:(NSInteger)rowIndex Column:(NSInteger)columnIndex 
{
    
    /*判断 column row 是否有效 */
    if ([ self isValidRow:rowIndex isValidColumn:columnIndex] == NO)
    {
        return;
    }
    
    NSMutableDictionary *caculateAreaDictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray *queue = [[NSMutableArray alloc]init];
    
    
    [self fillCaculate:caculateAreaDictionary fillQueue:queue row:rowIndex column:columnIndex];

    while(queue.count > 0)
    {
        @autoreleasepool
        {
            /*queue存储的是数组index*/
            
            /*取出队列中第一个成员*/
            NSValue *value = queue.firstObject;
            
            CGPoint point = [value CGPointValue];
            
            NSInteger rowInteger = (NSInteger)point.x;
            
            NSInteger columnInteger = (NSInteger)point.y;
           
            [self visit8AroundArea:caculateAreaDictionary fillQueue:queue row:rowInteger column:columnInteger];
           
            /*删除队列中成员*/
            [queue removeObject:value];
        }
    }
    
    [self updateMineDrawArray: caculateAreaDictionary];
}

/*根据row column 判断当前是否是雷区*/
-(BOOL) isMineFlagFromRow:(NSInteger)rowInteger FromColumn:(NSInteger)columnInteger
{
    
    NSNumber * mineDrawIndex;
    [Mine rowAndColumn2Index:&mineDrawIndex row:rowInteger column:columnInteger];
    
    return [self mineFlagSetContainObject:mineDrawIndex];
}

-(NSNumber *) mineDrawInstanceFromRow:(NSInteger)rowInteger FromColumn:(NSInteger)columnInteger
{
    
    NSNumber * mineDrawIndex = [[NSNumber alloc]init];
    
    [Mine rowAndColumn2Index : &mineDrawIndex row:rowInteger column: columnInteger];
    
    NSNumber * mineDrawInstance = [_mineDrawArray objectAtIndex:mineDrawIndex.integerValue];
    
    return mineDrawInstance;
}

-(void)fillCaculate:(NSMutableDictionary *)caculateAreadictionary fillQueue:(NSMutableArray*)queue row:(NSInteger)rowInteger column:(NSInteger)columnInteger
{
    NSInteger valueInRealArea =  [[[mineRealArray objectAtIndex: rowInteger] objectAtIndex:columnInteger]integerValue];
    
    NSNumber *index = [[NSNumber alloc]init];
    [[self class]rowAndColumn2Index: &index row:rowInteger column:columnInteger];

    NSInteger valueInMineDrawArray = [[self getObjectFromMineDrawArray: index.integerValue]integerValue];
    
    BOOL mineFlagByUser = [self isMineFlagFromRow:rowInteger FromColumn:columnInteger];
    
    if((MINE_INTEGER_FLAG != valueInRealArea) /*当前位置确实不是雷区*/
       && (NO == mineFlagByUser)/*没有被用户标记成雷区*/
       && (MINE_BLANK_HUMP == valueInMineDrawArray)
       && (NO == [caculateAreadictionary.allKeys containsObject:index]))
    {
        
        if(valueInRealArea == blankInMineRealArea)
        {
           CGPoint minePoint = CGPointMake(rowInteger, columnInteger);
           [queue addObject: [NSValue valueWithCGPoint: minePoint]];
        }
        
        mineType type = [[self class] mineRealArea2mineDrawArea:valueInRealArea];
        
        [caculateAreadictionary setObject:[[NSNumber alloc] initWithInteger: type] forKey:index]; /*visit mineDrawInstance*/

    }
}

-(void)visit8AroundArea:(NSMutableDictionary *)caculateAreadictionary fillQueue:(NSMutableArray*)queue row:(NSInteger)rowInteger column:(NSInteger)columnInteger
{
    //NSLog(@"%@",@"visit8AroundArea enter");
    for(NSInteger i = rowInteger -1;i <= rowInteger+1;i++)
    {
        for(NSInteger j = columnInteger -1;j <= columnInteger+1;j++)
        {
            @autoreleasepool
            {
                if ([ self isValidRow:i isValidColumn:j] != NO)
                {
                    if(!((i == rowInteger) && (j == columnInteger)))
                    {
                        [self fillCaculate:caculateAreadictionary fillQueue:queue row:i column:j];
                    }
                }
            }
            
        }
        
    }
    //NSLog(@"%@",@"visit8AroundArea leave");


}

-(void)singleHitIndex:(NSInteger)index
{
    NSLog(@"%@",@"singleHitIndex enter");

    NSNumber *number = [self getObjectFromMineDrawArray: index];
    
    if(number.integerValue == (int)MINE_BLANK_HUMP)
    {
        [self caclulateMineAreaIndex:index];
        NSThread * threadID = [NSThread currentThread];
        
        NSLog(@"%@",threadID);
    }
    
    NSLog(@"%@",@"singleHitIndex leave");
}
-(void)doubleHitIndex:(NSInteger)index
{
    NSLog(@"%@",@"doubleHitIndex enter");
    NSNumber *number = [self getObjectFromMineDrawArray: index];
    
    // MINE_BLANK_HUMP->MINE_FLAG
    if(MINE_BLANK_HUMP == (mineType)number.integerValue)
    {
        NSNumber *number = [[NSNumber alloc]initWithInteger: (int)MINE_FLAG];
        [self replaceMineDrawIndex: index withObject:number];
        [self addObjectToMineFlagSet: number];
                /*被标记成雷区*/
    }
    //MINE_FLAG ->MINE_BLANK_HUMP
    else if(MINE_FLAG  == (mineType)number.integerValue)
    {
        NSNumber *number = [[NSNumber alloc]initWithInteger: (int)MINE_BLANK_HUMP];
        [self replaceMineDrawIndex: index withObject:number];
        [self removeObjectFromMineFlagSet: number];
    }
    
    
    NSLog(@"%@",@"doubleHitIndex leave");
    return;
}


/*接收消息与发送消息必须在同一个线程，所以必须在主线程中post消息*/

-(void)notificateUpdate
{
    [[NSNotificationCenter defaultCenter]postNotificationName:(NSString*)notificationName object:self userInfo:nil];
}

-(void)printmineRealArray
{
    for(NSInteger i = 0; i < MINE_NUM_ROW;i++)
    {
        for(NSInteger j =0 ;j< MINE_NUM_COLUMN;j++)
        {
            NSNumber *num = [[mineRealArray objectAtIndex:i]objectAtIndex:j];
            
            printf("%02ld  ",num.integerValue);
        }
        printf("\r\n");
    }
}

-(void)addObjectToMineFlagSet:(id)object
{
    dispatch_barrier_async(_concurrent_queue_mineflagset, ^{
        [self.mineFlagSet addObject:object];
    });
}

-(void)removeObjectFromMineFlagSet:(id)object
{
    dispatch_barrier_async(_concurrent_queue_mineflagset, ^{
        [self.mineFlagSet removeObject:object];
    });
}


-(BOOL)mineFlagSetContainObject:(id)object
{
    __block BOOL bContainObject = NO;
    dispatch_sync(_concurrent_queue_mineflagset, ^{
        bContainObject = [self.mineFlagSet containsObject:object];
    });
    return bContainObject;
}

-(NSNumber *)getObjectFromMineDrawArray:(NSInteger)index
{
//    __block NSNumber * number = nil;
//    dispatch_sync(_concurrent_queue_minedrawarray, ^{
//        number = [self.mineDrawArray objectAtIndex:index];
//    });
    
    NSNumber * number = nil;
    @synchronized(_minedrawarraySysnObject)
    {
        number = [self.mineDrawArray objectAtIndex:index];
    }
    return number;
}

-(void)addObjectToMineDrawArray:(id)object
{
//    dispatch_barrier_async(_concurrent_queue_minedrawarray, ^{
//        [self.mineDrawArray addObject:object];
//    });
    
    @synchronized(_minedrawarraySysnObject)
    {
        [self.mineDrawArray addObject:object];
    }
}


-(void)replaceMineDrawIndex :(NSInteger)index withObject:(id)object
{
//    dispatch_barrier_async(_concurrent_queue_minedrawarray, ^{
//        [self.mineDrawArray replaceObjectAtIndex:index withObject:object];
//    });
    
    @synchronized(_minedrawarraySysnObject)
    {
        [self.mineDrawArray replaceObjectAtIndex:index withObject:object];
    }
}

-(void)replaceMineDrawWithDictionary :(NSMutableDictionary *)updateDictionary
{
     //__weak Mine * weakself = self;
    
//    dispatch_barrier_async(_concurrent_queue_minedrawarray, ^{
//       SEL replaceMineDrawIndexwithObjectSel = @selector(replaceMineDrawIndex:withObject:);
//       IMP replaceMineDrawIndexImp = [self methodForSelector:replaceMineDrawIndexwithObjectSel];
//       
//
//        for(NSNumber *index in updateDictionary.allKeys)
//        {
//            NSNumber * mineType = [updateDictionary objectForKey:index];
//            replaceMineDrawIndexImp(self,replaceMineDrawIndexwithObjectSel,index.integerValue,mineType);
//            //[self replaceMineDrawIndex:index.integerValue withObject: mineType];
//        }
//    });
    
    @synchronized(_minedrawarraySysnObject)
    {
//        SEL replaceMineDrawIndexwithObjectSel = @selector(replaceMineDrawIndex:withObject:);
//        IMP replaceMineDrawIndexImp = [self methodForSelector:replaceMineDrawIndexwithObjectSel];
        
        
        for(NSNumber *index in updateDictionary.allKeys)
        {
            NSNumber * mineType = [updateDictionary objectForKey:index];
//            replaceMineDrawIndexImp(self,replaceMineDrawIndexwithObjectSel,index.integerValue,mineType);
            [self replaceMineDrawIndex:index.integerValue withObject: mineType];
        }
    }
}

-(NSMutableArray *)getMineDrawArray
{
//    __block NSMutableArray * returnDrawArray = nil;
//    dispatch_sync(_concurrent_queue_minedrawarray, ^{
//        returnDrawArray =  self.mineDrawArray;
//    });
    
    NSMutableArray * returnDrawArray = nil;
    @synchronized(_minedrawarraySysnObject)
    {
        returnDrawArray =  self.mineDrawArray;
    }
    return returnDrawArray;
}


-( void)updateMineDrawArray:(NSMutableDictionary *)updateDictionary
{
    [self replaceMineDrawWithDictionary :updateDictionary];
    
    self.IndexPathArray = [[self class] items2IndexPaths:updateDictionary.allKeys];
    //NSLog(@"%@",@"updateMineDrawArray end");
}

+(mineType)mineRealArea2mineDrawArea:(NSInteger)mineRealArea
{
    mineType type = MINE_INVALID;
    if(MINE_INTEGER_FLAG == mineRealArea)
    {
        type = MINE_THUNDER;
       
    }
    else
    {
        type = MINE_BLANK - (mineType)mineRealArea;
    }
    return type;
}

+(NSMutableArray *)items2IndexPaths:(NSArray *)itemArray
{
    
    NSMutableArray *IndexPathArray = [[NSMutableArray alloc]init];
    for(NSNumber *item in itemArray)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item.integerValue inSection:(sectionNum-1)];
        [IndexPathArray addObject:indexPath];
    }
    return IndexPathArray;
}

-(Memento *)createMemento:(NSMutableDictionary *)mutableDictionary
{
    Memento *memento = [[Memento alloc]init];
    memento.mementoMutableDictionary = (__bridge_transfer NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFPropertyListRef)(mutableDictionary), kCFPropertyListMutableContainers);
    
    return  memento;
}

-(NSMutableDictionary *)resolveMemento:(Memento *)memento
{
    if(nil != memento)
    {
        NSMutableDictionary * mutableDictionary = nil;
        
        mutableDictionary = (__bridge_transfer NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFPropertyListRef)(memento.mementoMutableDictionary), kCFPropertyListMutableContainers);
        
        return mutableDictionary;
    }
   
    return nil;
   
}

-(void)dealloc
{
    
}
@end
