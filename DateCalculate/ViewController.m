//
//  ViewController.m
//  DateCalculate
//
//  Created by qinman on 16/8/10.
//  Copyright © 2016年 qinman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UIDatePicker *_datePicker1;
    UIDatePicker *_datePicker2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [self calcula];
}

//TEST
- (void)createDatePickerView {
    _datePicker1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 100)];
    _datePicker1.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker1.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    [self.view addSubview:_datePicker1];
    
    _datePicker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 230, 320, 100)];
    _datePicker2.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker2.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    [self.view addSubview:_datePicker2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self createDatePickerView];
    
    NSDate *againDate = [self dateWithString:@"2016-12-31 03:16"];
    _datePicker1.date = againDate;
    //    NSLog(@"currentDateStr = %@",currentDateStr);
    //    NSLog(@"againDate = %@",againDate);
    NSDate *date = [self dateAfterMonths:againDate gapMonth:2];
    _datePicker2.date = date;
    NSLog(@"againDate = %@ date = %@",againDate,date);
    //    NSLog(@"dateStr = %@",[self StringWithDate:date]);
    //    NSLog(@"%zd",[[NSTimeZone localTimeZone] secondsFromGMT]);
    //    NSLog(@"[NSTimeZone knownTimeZoneNames]:%@",[NSTimeZone knownTimeZoneNames]);
    
}

//下一个期限，几个月后的日期
- (NSDate *)dateAfterMonths:(NSDate *)currentDate gapMonth:(NSInteger)mountCount {
    //获取当年的总月数，当月的总天数
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitCalendar fromDate:currentDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    NSString *dateStr = @"";
    NSInteger endDay = 0;//天
    NSDate *newDate = [NSDate date];//新的年&月
    //判断是否是下一年
    if (components.month+mountCount > 12) {
        //是下一年
        dateStr = [NSString stringWithFormat:@"%zd-%zd-01 %zd:%zd",components.year+(components.month+mountCount)/12,(components.month+mountCount)%12,components.hour,components.minute];
        newDate = [formatter dateFromString:dateStr];
        //新月份的天数
        NSInteger newDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
        if ([self isEndOfTheMonth:currentDate]) {//当前日期处于月末
            endDay = newDays;
        } else {
            endDay = newDays < components.day?newDays:components.day;
        }
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd %zd:%zd",components.year+(components.month+mountCount)/12,(components.month+mountCount)%12,endDay,components.hour,components.minute];
    } else {
        //依然是当前年份
        dateStr = [NSString stringWithFormat:@"%zd-%zd-01 %zd:%zd",components.year,components.month+mountCount,components.hour,components.minute];
        newDate = [formatter dateFromString:dateStr];
        //新月份的天数
        NSInteger newDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
        if ([self isEndOfTheMonth:currentDate]) {//当前日期处于月末
            endDay = newDays;
        } else {
            endDay = newDays < components.day?newDays:components.day;
        }
        
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd %zd:%zd",components.year,components.month+mountCount,endDay,components.hour,components.minute];
    }
    
    newDate = [formatter dateFromString:dateStr];
    return newDate;
}

//判断是否是月末
- (BOOL)isEndOfTheMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger daysInMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSDateComponents *componets = [calendar components:NSCalendarUnitDay fromDate:date];
    if (componets.day >= daysInMonth) {
        return YES;
    }
    return NO;
}

- (NSDate *)dateWithString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

- (NSString *)StringWithDate:(NSDate *)date{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *fixString = [dateFormatter stringFromDate:date];
    return fixString;
}

- (void)calcula {
    NSDateComponents *componets = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitCalendar fromDate:[NSDate date]];
    NSString *dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd",componets.year+1,componets.month,componets.day-1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *myDate = [formatter dateFromString:dateStr];
    //    NSDate *myDate = [formatter dateFromString:@"2016-3-1"];
    NSDate *newDate = [myDate dateByAddingTimeInterval:-24*3600];
    
}

@end