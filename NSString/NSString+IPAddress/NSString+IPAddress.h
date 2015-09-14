//
//  NSString+IPAddressFinder.h
//  MYI_Socket
//
//  Created by Ajay Mehra on 11/09/15.
//  Copyright (c) 2015 Zapbuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IPAddress)

/**
 @brief This NSString Categeory will retrun IP Address of cellular network available in device of type IPv4.
 @discussion This method will find user cell network ip address and return the IP address to user of type IPv4.
 @param none
 @return IP Address of cellular network of type IPv4 otherwise nil if IP not found.
 @author Ajay Singh Mehra
 */

+ (NSString *)ipv4Cellular;
/**
 @brief This NSString Categeory will retrun IP Address of cellular network available in device of type IPv6.
 @discussion This method will find user cell network ip address and return the IP address to user of type IPv6.
 @param none
 @return IP Address of cellular network of type IPv4 otherwise nil if IP not found.
 @author Ajay Singh Mehra
 */

+ (NSString *)ipv6Cellular;
/**
 @brief This NSString Categeory will retrun IP Address of wifi network available in device of type IPv4.
 @discussion This method will find user wifi network ip address and return the IP address to user of type IPv4.
 @param none
 @return IP Address of wifi network of type IPv4 otherwise nil if IP not found.
 @author Ajay Singh Mehra
 */
+ (NSString *)ipv4WiFI;
/**
 @brief This NSString Categeory will retrun IP Address of wifi network available in device of type IPv6.
 @discussion This method will find user cell network ip address and return the IP address to user of type IPv6.
 @param none
 @return IP Address of wifi network of type IPv4 otherwise nil if IP not found.
 @author Ajay Singh Mehra
 */
+ (NSString *)ipv6WiFI;
/**
 @brief This NSString Categeory will retrun IP Address of localHost network available in device of type IPv4.
 @discussion This method will find user localHost network ip address and return the IP address to user of type IPv4.
 @param none
 @return IP Address of localHost network of type IPv4 otherwise nil if IP not found.
 @author Ajay Singh Mehra
 */
+ (NSString *)ipv4LocalHost;
/**
 @brief This NSString Categeory will retrun IP Address of localHost network available in device of type IPv6.
 @discussion This method will find user localHost network ip address and return the IP address to user of type IPv6.
 @param none
 @return IP Address of localHost network of type IPv6 otherwise nil if IP not found.
 @author Ajay Singh Mehra
 */
+ (NSString *)ipv6LocalHost;

@end
