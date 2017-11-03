//
//  server.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#ifndef server_h
#define server_h

#define admin 0

#define Debug 0

#if Debug
#define cRequestDomain            @"http://192.168.1.2:9009"     /**/
#define cHttpRequestDomain        @"http://192.168.1.2:9009"
#else
#define cRequestDomain            @"https://app.fitflow.io"     /**/
#define cHttpRequestDomain        @"http://manage.fitflow.io"
#endif

#define NETWORK_ERROR_ALERT @"Network error. \nPlease try again."

#endif /* server_h */
