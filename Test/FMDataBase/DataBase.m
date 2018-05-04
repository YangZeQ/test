//
//  DataBase.m
//  Test
//
//  Created by Developer on 2018/5/4.
//  Copyright © 2018年 Developer. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"

static DataBase *_DBCtl = nil;
@interface DataBase ()<NSCopying, NSMutableCopying>
@property (nonatomic, strong)FMDatabase *db;
@end

@implementation DataBase

+(instancetype)sharedDataBase{
    if (_DBCtl == nil) {
        _DBCtl = [[DataBase alloc] init];
        [_DBCtl initDataBase];
    }
    return _DBCtl;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl = [super allocWithZone:zone];
    }
    return _DBCtl;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return self;
}

-(void)initDataBase{
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    NSLog(@"filepath%@", filePath);
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    
    // 初始化数据表
    NSString *personSql = @"CREATE TABLE 'person' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'person_id' VARCHAR(255),'person_name' VARCHAR(255),'person_age' VARCHAR(255),'person_number'VARCHAR(255)) ";
    NSString *carSql = @"CREATE TABLE 'fmdn' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'car_id' VARCHAR(255),'car_brand' VARCHAR(255),'car_price'VARCHAR(255)) ";
    NSString *testSql = @"CREATE TABLE 'test' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'name' VARCHAR(255))";

    [_db executeUpdate:personSql];
    [_db executeUpdate:carSql];
    [_db executeUpdate:testSql];
    
    [_db close];
    
}
@end
