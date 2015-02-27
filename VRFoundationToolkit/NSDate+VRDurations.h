//
//  NSDate+VRDurations.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 11/29/12.
//  Copyright (c) 2012 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (VRDurations)

-(NSDate *)endOfDay;

-(NSInteger)yearsUntilDate:(NSDate*)nextDate;
-(NSInteger)monthsUntilDate:(NSDate*)nextDate;
-(NSInteger)daysUntilDate:(NSDate*)nextDate;
-(NSInteger)hoursUntilDate:(NSDate*)nextDate;
-(NSInteger)minutesUntilDate:(NSDate*)nextDate;
-(NSDateComponents*)componentsWithUnits:(NSCalendarUnit)units untilDate:(NSDate*)nextDate;
-(NSDateComponents*)componentsWithUnits:(NSCalendarUnit)units;
-(BOOL)isEqualToDate:(NSDate*)nextDate byUnits:(NSCalendarUnit)units;

+ (NSCalendar*)defaultCalendar;

@end
