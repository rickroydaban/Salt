//
//  CellMyCalendarDate.m
//  Salt
//
//  Created by Rick Royd Aban on 6/22/15.
//  Copyright (c) 2015 Applus Velosi. All rights reserved.
//

#import "CellMyCalendarDate.h"
#import "VelosiColors.h"

@interface CellMyCalendarDate(){
    VCMyCalendar *_vcMyCalendar;
}
@end

@implementation CellMyCalendarDate

- (void)assignVCMyCalendar:(VCMyCalendar *)myCalendar{
    _vcMyCalendar = myCalendar;
}

- (IBAction)button1Clicked:(id)sender {
    _propLabel1.superview.layer.borderWidth = 1;
    _propLabel1.superview.layer.borderColor = [VelosiColors orangeVelosi].CGColor;
//    _propLabel1.superview.layer.cornerRadius = 5.0f;
    
    [_vcMyCalendar calendarItemClicked:sender];
}

- (IBAction)button2Clicked:(id)sender {
    _propLabel2.superview.layer.borderWidth = 1;
    _propLabel2.superview.layer.borderColor = [VelosiColors orangeVelosi].CGColor;
//    _propLabel2.superview.layer.cornerRadius = 5.0f;

    [_vcMyCalendar calendarItemClicked:sender];
}

- (IBAction)button3Clicked:(id)sender {
    _propLabel3.superview.layer.borderWidth = 1;
    _propLabel3.superview.layer.borderColor = [VelosiColors orangeVelosi].CGColor;
//    _propLabel3.superview.layer.cornerRadius = 5.0f;

    [_vcMyCalendar calendarItemClicked:sender];
}

- (IBAction)button4Clicked:(id)sender {
    _propLabel4.superview.layer.borderWidth = 1;
    _propLabel4.superview.layer.borderColor = [VelosiColors orangeVelosi].CGColor;
//    _propLabel4.superview.layer.cornerRadius = 5.0f;

    [_vcMyCalendar calendarItemClicked:sender];
}

- (IBAction)button5Clicked:(id)sender {
    _propLabel5.superview.layer.borderWidth = 1;
    _propLabel5.superview.layer.borderColor = [VelosiColors orangeVelosi].CGColor;
//    _propLabel5.superview.layer.cornerRadius = 5.0f;

    [_vcMyCalendar calendarItemClicked:sender];
}

- (IBAction)button6Clicked:(id)sender {
    _propLabel6.superview.layer.borderWidth = 1;
    _propLabel6.superview.layer.borderColor = [VelosiColors orangeVelosi].CGColor;
//    _propLabel6.superview.layer.cornerRadius = 5.0f;

    [_vcMyCalendar calendarItemClicked:sender];
}

- (IBAction)button7Clicked:(id)sender {
    _propLabel7.superview.layer.borderWidth = 1;
    _propLabel7.superview.layer.borderColor = [VelosiColors orangeVelosi].CGColor;
//    _propLabel7.superview.layer.cornerRadius = 5.0f;

    [_vcMyCalendar calendarItemClicked:sender];
}

@end
