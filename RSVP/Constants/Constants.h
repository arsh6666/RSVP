//
//  Constants.h
//  Antilog Vacations
//
//  Created by Arshdeep Singh on 15/06/15.
//  Copyright (c) 2015 Rootfly Infotech. All rights reserved.
//

#ifndef InextDemo_Constants_h
#define InextDemo_Constants_h

//>>    Constant Strings
#define K_String_Constant   @"This is constant string"


//>>    APIs Urls

#define BaseURL                 @"http://www.hoteljkresidency.com/API/"
#define login                   (BaseURL @"Account/Login")
#define GETCATEGORY             (BaseURL @"Values/GetCategory")
#define GetWaitersbycategory    (BaseURL @"Values/GetWaitersbycategory")
#define GetTablesbycategory     (BaseURL @"Values/GetTablesbycategory")
#define SaveFeedback            (BaseURL @"Values/SaveFeedback")
#define GetClub                 (BaseURL @"Values/GetClub")
#define AddClub                 (BaseURL @"Values/AddClub")

//>>    Result Keys
#define K_Result            @"Success"


//>> Colors

#define redColor [UIColor colorWithRed:238.00/255.0 green:31.00/255.0 blue:37.00/255.0 alpha:1.00];
#define DarkGrayColor [UIColor colorWithRed:58.00/255.0 green:65.00/255.0 blue:76.00/255.0 alpha:1.00];
#define BlackColor [UIColor blackColor];

#endif
