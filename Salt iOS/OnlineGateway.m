//
//  OnlineGateway.m
//  Salt iOS
//
//  Created by Rick Royd Aban on 5/18/15.
//  Copyright (c) 2015 Rick Royd Aban. All rights reserved.
//

#import "OnlineGateway.h"
#import "AppDelegate.h"
#import "Leave.h"
#import "LocalHoliday.h"
#import "Holiday.h"

@interface OnlineGateway(){

    AppDelegate *_appDelegate;
    NSString *_apiUrl, *_root;
    NSDateFormatter *_dateTimeFormat;
}
@end

@implementation OnlineGateway

- (OnlineGateway *)initWithAppDelegate:(AppDelegate *)appDelegate{
    self = [super init];
    
    if(self){
        _appDelegate = appDelegate;
//        _apiUrl = @"https://salttestapi.velosi.com/SALTService.svc/";
        _apiUrl = @"https://saltapi.velosi.com/SALTService.svc/";
        _root = @"https://salt.velosi.com";
        _dateTimeFormat = [[NSDateFormatter alloc] init];
        _dateTimeFormat.dateFormat = @"yyyy-MM-dd%20HH:mm:ss";
    }
    
    return self;
}

- (id)httpsGetFrom:(NSString *)url{
//    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"ak0ayMa+apAn6" forHTTPHeaderField:@"AuthKey"];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if(responseCode.statusCode != 200)
        return [self responseErrorDescriptionFromStatusCode:(int)responseCode.statusCode];
    
    return responseData;
}

//returns nsdata if posted successfully otherwise returns a string message
- (id)httpPostFrom:(NSString *)url withBody:(NSString *)jsonString{
//    NSLog(@"%@",url);
//    NSLog(@"%@",jsonString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"%d",(int)jsonString.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"ak0ayMa+apAn6" forHTTPHeaderField:@"AuthKey"];
    request.HTTPBody = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if(responseCode.statusCode != 200)
        return [self responseErrorDescriptionFromStatusCode:(int)responseCode.statusCode];
    
    return responseData;
}
- (NSString *)responseErrorDescriptionFromStatusCode:(int)statusCode{
    switch (statusCode) {
        case 0: return @"Server Connection Failed";
        case 204: return @"No Response";
        case 400: return @"Bad Request";
        case 401: return @"Unauthorized";
        case 402: return @"Payment Required";
        case 403: return @"Forbidden";
        case 404: return @"Not Found";
        case 405: return @"Method Not Allowed";
        case 406: return @"Not Acceptable";
        case 407: return @"Proxy Authentication Required";
        case 408: return @"Request Timeout";
        case 409: return @"Conflict";
        case 410: return @"Gone";
        case 411: return @"Length Required";
        case 412: return @"Precondition Failed";
        case 413: return @"Request Entity Too Large";
        case 414: return @"Request-URI Too Long";
        case 415: return @"Unsupported Media Type";
        case 416: return @"Request Range Not Satisfiable";
        case 417: return @"Expectation Failed";
        case 500: return @"Internal Server Error";
        case 501: return @"Not Implemented";
        case 502: return @"Service temporarily overloaded";
        case 503: return @"Gateway Timeout";
        default:  return [NSString stringWithFormat:@"%d",statusCode];
    }
}

- (NSString *)deserializeJsonDateString: (NSString *)jsonDateString{
    @try{
        NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
        NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1; //start of the date value
        NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
        
        return [_appDelegate.propFormatVelosiDate stringFromDate:[[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset]];
    }@catch(NSException *e){
        return e.reason;
    }
}

- (NSString *)dateToday{
    return [_dateTimeFormat stringFromDate:[NSDate date]];
}

- (NSString *)authenticateUsername:(NSString *)username password:(NSString *)password{
    id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@AuthenticateLogin?userName=%@&password=%@&datetime=%@",_apiUrl,username,password,[self dateToday]]];

    NSError *error;
    @try{
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&error] objectForKey:@"AuthenticateLoginResult"];
        if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        else return [NSString stringWithFormat:@"%@-%@-%@",[result objectForKey:@"StaffID"],[result objectForKey:@"SecurityLevel"],[result objectForKey:@"OfficeID"]];
    }@catch(NSException *e){
        return @"Server connection failed";
    }
}

- (id)initializeDataWithStaffID:(int)staffID securityLevel:(int)securityLevel officeID:(int)officeID{
    NSString *updateStaffResultError = [self updateAppStaffDataWithStaffID:staffID securityLevel:securityLevel officeID:officeID];
    if(updateStaffResultError)
        return updateStaffResultError;
    
    id myLeaveResult = [self myLeaves];
    if([myLeaveResult isKindOfClass:[NSString class]])
        return myLeaveResult;
    
    id leavesForApprovalResult;
    if([[_appDelegate staff] isAdmin] || [[_appDelegate staff] isCM] || [[_appDelegate staff] isAM]){
        leavesForApprovalResult = [NSMutableArray array];
        if([leavesForApprovalResult isKindOfClass:[NSString class]])
            return leavesForApprovalResult;
    }

    [_appDelegate initMyLeaves:myLeaveResult leavesForApproval:leavesForApprovalResult];
    return nil;
}

- (NSString *)updateAppStaffDataWithStaffID:(int)staffID securityLevel:(int)securityLevel officeID:(int)officeID{
    id staffResultString = [self httpsGetFrom:[NSString stringWithFormat:@"%@GetStaffByID?staffID=%d&requestingPerson=%d&datetime=%@",_apiUrl, staffID, staffID, [self dateToday]]];
    id officeResultString = [self httpsGetFrom:[NSString stringWithFormat:@"%@GetOfficeByID?officeID=%d&requestingPerson=%d&datetime=%@",_apiUrl, officeID, staffID, [self dateToday]]];
    
    NSError *error;
    @try{
        NSDictionary *staffResult = [[NSJSONSerialization JSONObjectWithData:staffResultString options:0 error:&error] objectForKey:@"GetStaffByIDResult"];
        NSDictionary *officeResult = [[NSJSONSerialization JSONObjectWithData:officeResultString options:0 error:&error] objectForKey:@"GetOfficeByIDResult"];
        
        if([NSArray arrayWithArray:[staffResult objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[staffResult objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        
        if([NSArray arrayWithArray:[officeResult objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[officeResult objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        
        [_appDelegate updateStaffDataWithStaff:[[Staff alloc] initWithOnlineGateway:self staffDictionary:[staffResult objectForKey:@"Staff"]] office:[[Office alloc] initWithDictionary:[officeResult objectForKey:@"Office"] isFullDetail:true] key:self];
        
        return nil;
    }@catch(NSException *e){
       return [NSString stringWithFormat:@"Server connection failed %@",e.reason];
    }
}

- (id)myLeaves{
    @try{
        NSString *filter = [NSString stringWithFormat:@"WHERE year(DateFrom)=year(getdate()) AND StaffID=%d ORDER BY DateSubmitted DESC",[[_appDelegate staff] staffID]];
        id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@GetAllLeave?filter=%@&requestingperson=%d&datetime=%@",_apiUrl,[filter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[_appDelegate staff] staffID], [self dateToday]]];
        
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"GetAllLeaveResult"];
        if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        else{
            NSError *error = [[NSError alloc] init];
            
            NSMutableArray *leaves = [NSMutableArray array];
            NSArray *jsonLeaves = [result objectForKey:@"Leaves"];
            
            if(jsonLeaves){
                for(id jsonLeave in jsonLeaves)
                    [leaves addObject:[[Leave alloc] initWithJSONDictionary:jsonLeave onlineGateway:self]];
                return leaves;
            }else
                return error.localizedFailureReason;
        }
    }@catch(NSException *exception){
        return @"Server Connection Failed";
    }
}

- (id)leavesForApproval{
    @try{
        NSString *filter = [NSString stringWithFormat:@"WHERE (year(DateSubmitted)=Year(getdate()) OR year(DateFrom)=Year(getdate()-1)) AND (LeaveApprover1=%d OR LeaveApprover2=%d OR LeaveApprover3=%d) ORDER BY DateSubmitted DESC",[[_appDelegate staff] staffID], [[_appDelegate staff] staffID], [[_appDelegate staff] staffID]];
        
        id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@GetAllLeave?filter=%@&requestingperson=%d&datetime=%@",_apiUrl,[filter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[_appDelegate staff] staffID], [self dateToday]]];
        
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"GetAllLeaveResult"];
        if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        else{
            NSError *error = [[NSError alloc] init];
        
            NSMutableArray *leavesForApproval = [NSMutableArray array];
            NSArray *jsonLeaves = [result objectForKey:@"Leaves"];
            
            if(jsonLeaves){
                for(id jsonLeave in jsonLeaves)
                    [leavesForApproval addObject:[[Leave alloc] initWithJSONDictionary:jsonLeave onlineGateway:self]];
                return leavesForApproval;
            }else
                return error.localizedFailureReason;
        }
    }@catch(NSException *exception){
        return @"Server Connection Failed";
    }
}

- (id)localHolidays{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *monthFormatter =  [[NSDateFormatter alloc] init];
    dayFormatter.dateFormat = @"EEEE"; //getting the day name
    monthFormatter.dateFormat = @"LLLL"; //getting the month name
    
    @try{
        id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@GetNationalHolidaysByOffice?officeID=%d&requestingperson=%d&datetime=%@", _apiUrl,[[_appDelegate staff] officeID], [[_appDelegate staff] staffID], [self dateToday]]];
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"GetNationalHolidaysByOfficeResult"];

        if([NSArray arrayWithArray:[result objectForKey:@"SystemErros"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        else{
            NSError *error = [[NSError alloc] init];
            NSMutableArray *holidays = [NSMutableArray array];
            NSArray *jsonHolidays = [result objectForKey:@"NationalHolidays"];
            
            if(jsonHolidays){
                for(id jsonHoliday in jsonHolidays){
                    if([[jsonHoliday objectForKey:@"Active"] boolValue]){ //only active holidays must be retrieved
                        NSArray *jsonApplicableOffices =  [jsonHoliday objectForKey:@"OfficesApplied"];
                        for(id jsonApplicableOffice in jsonApplicableOffices){ //not all offices must observe a holiday so must recheck
                            if([[jsonApplicableOffice objectForKey:@"OfficeID"] intValue] == [[_appDelegate staff] officeID]){
                                NSString *dateStr = [self deserializeJsonDateString:[jsonHoliday objectForKey:@"Date"]];
                                if([[dateStr componentsSeparatedByString:@"-"][2] intValue] == [_appDelegate currYear]){
                                    NSDate *date = [_appDelegate.propFormatVelosiDate dateFromString:dateStr];
                                    [holidays addObject:[[LocalHoliday alloc] initWithName:[jsonHoliday objectForKey:@"Name"] date:dateStr day:[dayFormatter stringFromDate:date] month:[monthFormatter stringFromDate:date]]];
                                }
                                break;
                            }
                        }
                    }
                }
            }else
                return error.localizedFailureReason;
            
            return holidays;
        }
    }@catch(NSException *e){
        return @"Server Connection Failed";
    }
}

- (id)monthlyholidays{
//    NSMutableDictionary *flagDics = [NSMutableDictionary dictionary];
    
    @try{
        id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@GetAllNationalHoliday?requestingperson=%d&datetime=%@", _apiUrl, [[_appDelegate staff] officeID], [self dateToday]]];
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"GetAllNationalHolidayResult"];
        
        if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        else{
            NSMutableArray *holidays = [NSMutableArray array];
            NSArray *jsonHolidays = [result objectForKey:@"NationalHoliday"];
            
            if(jsonHolidays){
                for(id jsonHoliday in jsonHolidays){
                    if([[jsonHoliday objectForKey:@"Active"] boolValue]){
                        NSString *dateStr = [self deserializeJsonDateString:[jsonHoliday objectForKey:@"Date"]];
                        NSDate *date = [_appDelegate.propFormatVelosiDate dateFromString:dateStr];
    //                        NSString *tempFlagUrl = [jsonHoliday objectForKey:@"ImageURL"];
    //                        NSString *flagUrl = [NSString stringWithFormat:@"%@%@",_root,[tempFlagUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //                        if([flagDics objectForKey:flagUrl] == nil){ //flag is not saved yet
    //                            @try{
    //                                [flagDics setObject:[UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:flagUrl]]] forKey:flagUrl];
    //                            }@catch(NSException *exception){
    //                                NSLog(@"exception while getting image from url %@",exception.reason);
    //                                [flagDics setObject:[UIImage imageNamed:@"bg_white"] forKey:flagUrl];
    //                            }
    //                        }
                        Holiday *holiday = [[Holiday alloc] initWithName:[jsonHoliday objectForKey:@"Name"] country:[jsonHoliday objectForKey:@"Country"] velosiDateStr:dateStr monthYearDateStr:[_appDelegate.propDateFormatMonthyear stringFromDate:date] date:date];
                        for(id jsonApplicableOffice in [jsonHoliday objectForKey:@"OfficesApplied"]){
                            [holiday addOfficeName:[jsonApplicableOffice objectForKey:@"OfficeName"]];
                        }
                        
                        [holidays addObject:holiday];
                    }
                }
            }
            
            return holidays;
        }
    }@catch(NSException *e){
        NSLog(@"exception %@",e);
        return @"Server Connection Failed";
    }
}

- (id)weeklyholiday{
    id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@GetNationalHolidaysForTheWeek?requestingPerson=%d&datetime=%@", _apiUrl,[[_appDelegate staff] staffID], [self dateToday]]];
    NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"GetNationalHolidaysForTheWeekResult"];
    
    if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
        return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
    else{
        NSMutableArray *holidays = [NSMutableArray array];
        NSArray *jsonHolidays = [result objectForKey:@"NationalHoliday"];
        
        if(jsonHolidays){
            for(id jsonHoliday in jsonHolidays){
                if([[jsonHoliday objectForKey:@"Active"] boolValue]){
                    NSString *dateStr = [self deserializeJsonDateString:[jsonHoliday objectForKey:@"Date"]];
                    NSDate *date = [_appDelegate.propFormatVelosiDate dateFromString:dateStr];
                    
                    Holiday *holiday = [[Holiday alloc] initWithName:[jsonHoliday objectForKey:@"Name"] country:[jsonHoliday objectForKey:@"Country"] velosiDateStr:dateStr monthYearDateStr:[_appDelegate.propDateFormatMonthyear stringFromDate:date] date:date];
                    for(id jsonApplicableOffice in [jsonHoliday objectForKey:@"OfficesApplied"])
                        [holiday addOfficeName:[jsonApplicableOffice objectForKey:@"OfficeName"]];
                    
                    [holidays addObject:holiday];
                }
            }
        }
        
        return holidays;
    }
}

- (NSString *)followupLeave:(NSString *)leaveJSON{
    id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@EmailLeave?leave=%@&requestingPerson=%d&datetime=%@",_apiUrl, [leaveJSON stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[_appDelegate staff] officeID], [self dateToday]]];
    
    @try{
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"EmailLeaveResult"];
        if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        
        return nil;
    }@catch(NSException *exception){
        NSLog(@"Exception in follow up leaves %@",exception);
        return exception.reason;
    }
}

- (NSString *)saveLeaveWithNewLeaveJSON:(NSString *)newLeaveJSON oldLeaveJSON:(NSString *)oldLeaveJSON{
    id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@SaveLeave?newLeave=%@&oldLeave=%@&requestingperson=%d&datetime=%@",_apiUrl, newLeaveJSON, oldLeaveJSON, [[_appDelegate staff] staffID], [self dateToday]]];
    
    @try{
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"SaveLeaveResult"];
        if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        
        return nil;
    }@catch(NSException *exception){
        NSLog(@"Exception in save leave %@", exception);
        return exception.reason;
    }
}

- (NSString *)processLeaveJSON:(NSString *)leaveJSON forStatusID:(int)statusID{
    id data = [self httpsGetFrom:[NSString stringWithFormat:@"%@ApproveLeave?leave=%@&status=%d&requestingPerson=%d&datetime=%@", _apiUrl, leaveJSON, statusID, [[_appDelegate staff] staffID], [self dateToday]]];
    
    @try{
        NSDictionary *result = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"ApproveLeaveResult"];
        if([NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]].count > 0)
            return [[[NSArray arrayWithArray:[result objectForKey:@"SystemErrors"]] objectAtIndex:0] objectForKey:@"Message"];
        
        return nil;
    }@catch(NSException *exception){
        NSLog(@"Exception in follow up leaves %@", exception);
        return exception.reason;
    }
}

@end
