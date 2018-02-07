//
//  SHKData.h
//  SimpleHTTPKit
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface SHKData : NSData
{
    dispatch_data_t _ddata;
    const void* _buf;
    size_t _len;
}

-(instancetype)initWithDispatchData:(_Nonnull dispatch_data_t)data;
-(_Nullable dispatch_data_t)getDispatchData;

@end
