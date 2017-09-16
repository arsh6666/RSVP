//
//  ueService.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "Constants.h"

@class uesoapSecurityToken;
@class uesoapTransactionRequestObject;
@class uesoapCustomerTransactionResponse;
@class uesoapTransactionResponse;
@class uesoapBatchSearchResult;
@class uesoapTransactionSearchResult;
@class uesoapCustomerSearchResult;
@class uesoapProductSearchResult;
@class uesoapGpsLocation;
@class uesoapSyncLogArray;
@class uesoapProduct;
@class uesoapFieldValueArray;
@class uesoapProductCategory;

@interface uesoapService : NSObject {

	NSInvocationOperation *procOp;
	NSOperationQueue *opQueue;
	
	NSString *useHost;
}

@property(nonatomic, retain) Constants *constantManager;

-(void) setHost:(NSString *)host;

#pragma mark -
#pragma mark Customers

-(NSString *) addCustomer:(NSDictionary *)params;
-(void) addCustomerAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSString *) deleteCustomer:(NSDictionary *)params;
-(void) deleteCustomerAsync:(NSDictionary *)params delegate:(id)delegate;

-(uesoapCustomerSearchResult *) searchCustomers:(NSDictionary *)params;
-(void) searchCustomersAsync:(NSDictionary *)params delegate:(id)delegate;

-(uesoapTransactionResponse *) runCustomerTransaction:(NSDictionary *)params;
-(void) runCustomerTransaction_Background:(NSDictionary *)params;
-(void) runCustomerTransactionAsync:(NSDictionary *)params delegate:(id)object;

-(NSString *) quickUpdateCustomer:(NSDictionary *)params;
-(void) quickUpdateCustomerAsync:(NSDictionary *)params delegate:(id)object;

#pragma mark -
#pragma mark Transactions
-(uesoapTransactionResponse *) captureTransaction:(NSDictionary *)params;
-(void) captureTransactionAsync:(NSDictionary *)params delegate:(id)delegate;

-(uesoapTransactionResponse *) runTransaction:(NSDictionary *)params;
-(void) runTransaction_Background:(NSDictionary *)params;
-(void) runTransactionAsync:(NSDictionary *)params delegate:(id)object;

-(BOOL) voidTransaction:(NSDictionary *)params;
-(void) voidTransactionAsync:(NSDictionary *)params delegate:(id)delegate;

-(uesoapTransactionResponse *) runQuickSale:(NSDictionary *)params;
-(void) runQuickSaleAsync:(NSDictionary *)params delegate:(id)delegate;

-(uesoapTransactionResponse *) runQuickCredit:(NSDictionary *)params;
-(void) runQuickCreditAsync:(NSDictionary *)params delegate:(id)delegate;

-(BOOL) emailTransactionReceiptByName:(NSDictionary *)params;
-(void) emailTransactionReceiptByNameAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSArray *) getReceipts:(NSDictionary *)params;
-(void) getReceiptsAsync:(NSDictionary *)params delegate:(id)delegate;

-(uesoapTransactionSearchResult *) searchTransactions:(NSDictionary *)params;
-(void) searchTransactionsAsync:(NSDictionary *)params delegate:(id)delegate;


#pragma mark -
#pragma mark Batches
-(uesoapBatchSearchResult *) searchBatches:(NSDictionary *)params;
-(void) searchBatchesAsync:(NSDictionary *)params delegate:(id)delegate;

-(void) closeBatchAsync:(NSDictionary *)params delegate:(id)delegate;
-(BOOL) closeBatch:(NSDictionary *)params;

#pragma mark -
#pragma mark Products
-(NSString *) addProduct:(NSDictionary *)params;
-(void) addProductAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSString *) updateProduct:(NSDictionary *)params;
-(void) updateProductAsync:(NSDictionary *)params delegate:(id)delegate;

-(uesoapProductSearchResult *) searchProducts:(NSDictionary *)params;
-(void) searchProductsAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSString *) deleteProduct:(NSDictionary *)params;
-(void) deleteProductAsync:(NSDictionary *)params delegate:(id)delegate;

-(void) getSyncLogAsync:(NSDictionary *)params delegate:(id)delegate;
-(uesoapSyncLogArray *) getSyncLog:(NSDictionary *)params;

-(void) getSyncLogCurrentPositionAsync:(NSDictionary *)params delegate:(id)delegate;
-(NSNumber *) getSyncLogCurrentPosition:(NSDictionary *)params;

-(void) getProductAsync:(NSDictionary *)params delegate:(id)delegate;
-(uesoapProduct *) getProduct:(NSDictionary *)params;

#pragma mark -
#pragma mark ProductCategories
-(NSString *) addProductCategory:(NSDictionary *)params;
-(void) addProductCategoryAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSString *) updateProductCategory:(NSDictionary *)params;
-(void) updateProductCategoryAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSString *) deleteProductCategory:(NSDictionary *)params;
-(void) deleteProductCategoryAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSArray *)getProductCategories:(NSDictionary *)params;
-(void)getProductCategoriesAsync:(NSDictionary*)params delegate:(id)delegate;

-(void) getProductCategoryAsync:(NSDictionary *)params delegate:(id)delegate;
-(uesoapProductCategory *) getProductCategory:(NSDictionary *)params;

#pragma mark -
#pragma mark getReport implementation
-(void) getReportAsync:(NSDictionary *)params delegate:(id)delegate;
-(NSArray *) getReport:(NSDictionary *)params;

#pragma mark -
#pragma mark Custom Fields
-(uesoapFieldValueArray *) getCustomFields:(NSDictionary *)params;
-(void)getCustomFieldsAsync:(NSDictionary *)params delegate:(id)delegate;

#pragma mark -
#pragma mark Misc

-(uesoapGpsLocation *) findNearbyPostalCodes:(NSDictionary *)params;
-(void) findNearbyPostalCodesAsync:(NSDictionary *)params delegate:(id)delegate;

-(NSString *) buildSoapBody:(NSString *)method token:(uesoapSecurityToken *)token commandBody:(NSString *)commandBody;
-(void) parseForException:(NSString *)response;

+(NSString *) rawurlencode:(NSString *)rawdata;
+(NSString *) rawurlencodeAll:(NSString *)rawdata;
+(NSString *) rawurlencodeIOS7:(NSString *)rawdata;
+(NSString *) rawurlencodeCFString:(NSString *)rawdata;
-(NSString *) rawurldecode:(NSString *)rawdata;
-(NSString *) rawurldecodeAll:(NSString *)rawdata;
-(NSString *) decToChar:(int)dec;

-(NSString *) postToURL:(NSString *)url data:(NSString *)requestBody;
-(NSString *) postSoapToURL:(NSString *)url data:(NSString *)requestBody;

-(NSString *) getURL:(NSString *)uri;

@end
