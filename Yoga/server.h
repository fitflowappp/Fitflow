//
//  server.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#ifndef server_h
#define server_h

#define Debug 0

#define Debug_Heap  0

#if Debug
#define cRequestDomain            @"http://test.manage.fitflow.io" /**/
#define cHttpRequestDomain        @"http://test.app.fitflow.io"
#else
#define cRequestDomain            @"https://app.fitflow.io"     /**/
#define cHttpRequestDomain        @"http://manage.fitflow.io"
#endif

#define URLForge(tail)            URLCombine(cRequestDomain,tail)
#define URLImageForge(tail)       URLCombine(cHttpRequestDomain,tail)

#define URLCombine(domain,tail)   [NSString stringWithFormat:@"%@%@",domain,tail]

#define NETWORK_ERROR_ALERT @"Network error. \nPlease try again."

#endif /* server_h */
