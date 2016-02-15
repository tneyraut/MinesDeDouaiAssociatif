//
//  UserModel.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "UserModel.h"
#import "User.h"

@interface UserModel()

@property(nonatomic, strong) NSMutableData* downloadedDataUser;

@end

@implementation UserModel

- (void) getUser:(NSString *)login pass:(NSString *)password
{
    NSString *url = [NSString stringWithFormat:@"username=%@&password=%@", login, password];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/login", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) updateUser:(NSString *)chambre residence:(NSString *)residence telephone:(NSString *)telephone
{
    NSString *url = [NSString stringWithFormat:@"chambre=%@&residence=%@&telephone=%@", chambre, residence, telephone];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/updateProfile", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedDataUser = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedDataUser appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* _user = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedDataUser options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonArray != nil)
    {
        User *user = [[User alloc] init];
        user.user_id = [jsonArray[@"id"] intValue];
        user.login = jsonArray[@"username"];
        user.prenom = jsonArray[@"prenom"];
        user.nom = jsonArray[@"nom"];
        user.telephone = jsonArray[@"telephone"];
        user.residence = jsonArray[@"residence"];
        user.promotion = jsonArray[@"promo"][@"year"];
        user.avatar = jsonArray[@"avatar"];
        
        user.respo_notifications_mobiles = NO;
        
        user.administrateur = NO;
        
        user.airMember = NO;
        
        NSArray *rolesArray = jsonArray[@"assos"];
        for (int i=0;i<rolesArray.count;i++)
        {
            NSDictionary* dictionary = rolesArray[i];
            
            if ([dictionary[@"role"] isEqualToString:@"Respo notifications mobiles"])
            {
                user.respo_notifications_mobiles = YES;
            }
            else if ([dictionary[@"role"] isEqualToString:@"Administrateur"])
            {
                user.administrateur = YES;
            }
            if ([dictionary[@"nom"] isEqualToString:@"AIR"])
            {
                user.airMember = YES;
            }
        }
        
        if (![jsonArray[@"chambre"] isKindOfClass:[NSNull class]])
        {
            user.chambre = [NSString stringWithFormat:@"%d", [jsonArray[@"chambre"] intValue]];
        }
        else
        {
            user.chambre = (NSString*)jsonArray[@"chambre"];
        }
        
        [_user addObject:user];
    }
    
    if (self.delegate) {
        [self.delegate getUserDownloaded:_user];
    }
}

@end
