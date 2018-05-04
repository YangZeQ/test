//
//  Student.h
//  Test
//
//  Created by Developer on 2018/4/8.
//  Copyright © 2018年 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property (nonatomic,assign) int stuid;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSString *headimage;

@property (nonatomic,assign) int age;
@end
