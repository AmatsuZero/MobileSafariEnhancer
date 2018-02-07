//
//  SHKData.m
//  SimpleHTTPKit
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

#import "SHKData.h"

@implementation SHKData

-(instancetype)initWithDispatchData:(dispatch_data_t)data {
    if (self = [super init]) {
        _ddata = dispatch_data_create_map(data, &_buf, &_len);
    }
    return self;
}

-(dispatch_data_t)getDispatchData {
    return _ddata;
}

@end
