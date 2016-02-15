//
//  APIModel.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 23/09/2015.
//  Copyright © 2015 Thomas Mac. All rights reserved.
//

#import "APIModel.h"

@interface APIModel()

@property(nonatomic, strong) NSMutableData* download;

@end

@implementation APIModel

- (void)getAPI_url
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSLocalizedString(@"API_URL_DISTRIBUTION", @"API_URL_DISTRIBUTION") stringByAppendingString:[@"application/isProductionVersion?app=ios&version=" stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.download = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.download appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:self.download options:NSJSONReadingAllowFragments error:&error];
    
    float versionOnAppStore = [jsonArray[@"prodVersion"] floatValue];
    
    NSString *API_url = NSLocalizedString(@"API_URL_DISTRIBUTION", @"API_URL_DISTRIBUTION");
    
    BOOL updateToDo = NO;
    
    float appVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
    
    if (versionOnAppStore < appVersion)
    {
        API_url = NSLocalizedString(@"API_URL_PRODUCTION", @"API_URL_PRODUCTION");
    }
    else if (versionOnAppStore > appVersion)
    {
        updateToDo = YES;
    }
    
    if (self.delegate)
    {
        [self.delegate apiChosen:API_url updateToDo:updateToDo];
    }
}


@end
