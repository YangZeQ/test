//
//  StudentManager.h
//  Test
//
//  Created by Developer on 2018/4/8.
//  Copyright © 2018年 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
@interface StudentManager : NSObject
+(instancetype)shareManager;
//添加一条数据到数据表中
-(BOOL)addDataWithModel:(Student*)student ConditionString:(NSString *)conditionStr andconditionValue:(NSString *)conditionValue andtable:(NSString * )table;
//通过某个字段删除一条数据；
-(BOOL)deleteDataWithConditionString:(NSString *)conditionStr andconditionValue:(NSString *)conditionValue andtable:(NSString * )table;
//  删除所有的记录
- (BOOL)deleteAllDataWithtable:(NSString *)table;
//查询一条数据；
//1.查询全部数据，2根据特定字段查询数据；
-(NSArray * )getDataWithconditionString:(NSString * )conditionstr andConditionValue:(NSString *)conditionValue allData:(BOOL)isAllData andTable:(NSString *)table;
//修改某条数据
-(BOOL)updateDataWithString:(NSString*)NewStr andNewStrValue:(id)NewStrValue  andConditionStr:(NSString*)conditionStr andConditionValue:(NSString*)conditionValue andTable:(NSString*)table;
@end
