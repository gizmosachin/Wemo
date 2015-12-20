//
//  MacAddressHelper.m
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

#import "MacAddressHelper.h"

#if (TARGET_IPHONE_SIMULATOR)
#import <net/if_types.h>
#import <net/route.h>
#import <netinet/if_ether.h>
#else
#import "if_types.h"
#import "route.h"
#import "if_ether.h"
#endif

#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <net/if_dl.h>
#import <net/if.h>
#import <netinet/in.h>

@implementation MacAddressHelper

+ (NSString *)macAddressForIPAddress:(NSString*)ipAddress {
	NSString* res = nil;
	in_addr_t addr = inet_addr([ipAddress UTF8String]);
	
	size_t needed;
	char *buf, *next;
	
	struct rt_msghdr *rtm;
	struct sockaddr_inarp *sin;
	struct sockaddr_dl *sdl;
	
	int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_LLINFO};
	if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), NULL, &needed, NULL, 0) < 0) {
		NSLog(@"error in route-sysctl-estimate");
		return nil;
	}
	if ((buf = (char*)malloc(needed)) == NULL) {
		NSLog(@"error in malloc");
		return nil;
	}
	if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), buf, &needed, NULL, 0) < 0) {
		NSLog(@"retrieval of routing table");
		return nil;
	}
	for (next = buf; next < buf + needed; next += rtm->rtm_msglen) {
		rtm = (struct rt_msghdr *)next;
		sin = (struct sockaddr_inarp *)(rtm + 1);
		sdl = (struct sockaddr_dl *)(sin + 1);
		
		if (addr != sin->sin_addr.s_addr || sdl->sdl_alen < 6) continue;
		u_char *cp = (u_char*)LLADDR(sdl);
		res = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
		break;
	}
	
	free(buf);
	return res;
}

@end
