//
//  NSString+IPAddressFinder.m
//  MYI_Socket
//
//  Created by Ajay Mehra on 11/09/15.
//  Copyright (c) 2015 Zapbuild. All rights reserved.
//

#import "NSString+IPAddress.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static NSString * const cellularIPv4Key   =  @"pdp_ip0/ipv4";
static NSString * const cellularIPv6Key   =  @"pdp_ip0/ipv6";
static NSString * const WiFiIPv4Key       =  @"en0/ipv4";
static NSString * const WiFiIPv6Key       =  @"en0/ipv6";
static NSString * const localHostIPv4Key  =  @"lo0/ipv4";
static NSString * const localHostIPv6Key  =  @"lo0/ipv6";

@implementation NSString (IPAddress)


+ (NSString *)ipv4Cellular{
    return [self getDeviceIPAddress:YES withKey:cellularIPv4Key];
}


+ (NSString *)ipv6Cellular{
    return [self getDeviceIPAddress:NO withKey:cellularIPv6Key];
}

+ (NSString *)ipv4WiFI{
     return [self getDeviceIPAddress:YES withKey:WiFiIPv4Key];
}

+ (NSString *)ipv6WiFI{
     return [self getDeviceIPAddress:NO withKey:WiFiIPv6Key];
}

+ (NSString *)ipv4LocalHost{
    
     return [self getDeviceIPAddress:YES withKey:localHostIPv4Key];
}

+ (NSString *)ipv6LocalHost{
    
     return [self getDeviceIPAddress:NO withKey:localHostIPv6Key];
}

/**
 @brief This Method will return IP Address of User Device according to key and Network Version provide by caller.
 @param network version IPv4 in YES or No. 
 @param Key Network Key
 @return IP Address.
 @author Ajay Singh Mehra
 */



+ (NSString *)getDeviceIPAddress:(BOOL)preferIPv4 withKey:(NSString *)key{
    
    //1. Create an Search Array of Prefer type. ipv4 or ipv6.
    
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    //2. Call getDeviceIPAddresses method to get All Available IP.
    
    NSDictionary *addresses = [self getDeviceIPAddresses];
   // NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    
    [searchArray enumerateObjectsUsingBlock:^(NSString *ipKey, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    
    return address ? address : nil;
    
}
/**
 @brief This method will return all IP Address available regarding a iOS device.
 @param none.
 @return Set of IP Addresses in form of nsdictionary.
 @author Ajay Singh Mehra
 */


+ (NSDictionary *)getDeviceIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary new];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}



@end
