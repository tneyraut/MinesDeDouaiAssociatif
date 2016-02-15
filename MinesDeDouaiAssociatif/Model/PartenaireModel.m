//
//  PartenaireModel.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "PartenaireModel.h"
#import "Partenaire.h"

@interface PartenaireModel()

@property(nonatomic, strong) NSMutableData* downloadedDataPartenaires;

@end

@implementation PartenaireModel

- (void) getPartenairesByAssociation:(int)association_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@partenaire/list?association_id=%d", self.API_url, association_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getAllPartenaires
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@partenaire/list", self.API_url]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedDataPartenaires = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedDataPartenaires appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray* partenaires = [[NSMutableArray alloc] init];
    
    NSMutableArray* partenairesRestauration = [[NSMutableArray alloc] init];
    
    NSMutableArray* partenairesLoisirs = [[NSMutableArray alloc] init];
    
    NSMutableArray* partenairesInformatique = [[NSMutableArray alloc] init];
    
    NSMutableArray* partenairesAutres = [[NSMutableArray alloc] init];
    
    NSError* error;
    
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedDataPartenaires options:NSJSONReadingAllowFragments error:&error];
    
    NSArray* jsonElementRestauration = jsonArray[@"Restauration"];
    
    NSArray* jsonElementLoisirs = jsonArray[@"Loisirs"];
    
    NSArray* jsonElementInformatique = jsonArray[@"Informatique"];
    
    NSArray* jsonElementAutres = jsonArray[@"Autres partenaires utiles"];
    
    for (int i=0;i<jsonElementRestauration.count; i++)
    {
        NSDictionary* jsonElement = jsonElementRestauration[i];
        
        Partenaire* partenaire = [[Partenaire alloc] init];
        
        partenaire.partenaire_id = [jsonElement[@"id"] intValue];
        
        partenaire.telephone = (NSString*)jsonElement[@"telephone"];
        
        partenaire.siteweb = (NSString*)jsonElement[@"siteweb"];
        
        [self setAdressePartenaire:partenaire rue:(NSString*)jsonElement[@"rue"] ville:(NSString*)jsonElement[@"ville"] codePostal:(NSString*)jsonElement[@"codePostal"]];
        
        partenaire.offre =  (NSString*)jsonElement[@"offre"];
        
        partenaire.nom = (NSString*)jsonElement[@"nom"];
        
        partenaire.logo = (NSString*)jsonElement[@"logo"];
        
        [partenairesRestauration addObject:partenaire];
    }
    
    for (int i=0;i<jsonElementLoisirs.count; i++)
    {
        NSDictionary* jsonElement = jsonElementLoisirs[i];
        
        Partenaire* partenaire = [[Partenaire alloc] init];
        
        partenaire.partenaire_id = [jsonElement[@"id"] intValue];
        
        partenaire.telephone = (NSString*)jsonElement[@"telephone"];
        
        partenaire.siteweb = (NSString*)jsonElement[@"siteweb"];
        
        [self setAdressePartenaire:partenaire rue:(NSString*)jsonElement[@"rue"] ville:(NSString*)jsonElement[@"ville"] codePostal:(NSString*)jsonElement[@"codePostal"]];
        
        partenaire.offre = (NSString*)jsonElement[@"offre"];
        
        partenaire.nom = (NSString*)jsonElement[@"nom"];
        
        partenaire.logo = (NSString*)jsonElement[@"logo"];
        
        [partenairesLoisirs addObject:partenaire];
    }
    
    for (int i=0;i<jsonElementInformatique.count; i++)
    {
        NSDictionary* jsonElement = jsonElementInformatique[i];
        
        Partenaire* partenaire = [[Partenaire alloc] init];
        
        partenaire.partenaire_id = [jsonElement[@"id"] intValue];
        
        partenaire.telephone = (NSString*)jsonElement[@"telephone"];
        
        partenaire.siteweb = (NSString*)jsonElement[@"siteweb"];
        
        [self setAdressePartenaire:partenaire rue:(NSString*)jsonElement[@"rue"] ville:(NSString*)jsonElement[@"ville"] codePostal:(NSString*)jsonElement[@"codePostal"]];
        
        partenaire.offre = (NSString*)jsonElement[@"offre"];
        
        partenaire.nom = (NSString*)jsonElement[@"nom"];
        
        partenaire.logo = (NSString*)jsonElement[@"logo"];
        
        [partenairesInformatique addObject:partenaire];
    }
    
    for (int i=0;i<jsonElementAutres.count; i++)
    {
        NSDictionary* jsonElement = jsonElementAutres[i];
        
        Partenaire* partenaire = [[Partenaire alloc] init];
        
        partenaire.partenaire_id = [jsonElement[@"id"] intValue];
        
        partenaire.telephone = (NSString*)jsonElement[@"telephone"];
        
        partenaire.siteweb = (NSString*)jsonElement[@"siteweb"];
        
        [self setAdressePartenaire:partenaire rue:(NSString*)jsonElement[@"rue"] ville:(NSString*)jsonElement[@"ville"] codePostal:(NSString*)jsonElement[@"codePostal"]];
        
        partenaire.offre = (NSString*)jsonElement[@"offre"];
        
        partenaire.nom = (NSString*)jsonElement[@"nom"];
        
        partenaire.logo = (NSString*)jsonElement[@"logo"];
        
        [partenairesAutres addObject:partenaire];
    }
    
    [partenaires addObject:partenairesRestauration];
    
    [partenaires addObject:partenairesLoisirs];
    
    [partenaires addObject:partenairesInformatique];
    
    [partenaires addObject:partenairesAutres];
    
    if (self.delegate)
    {
        [self.delegate partenairesDownloaded:partenaires];
    }
}

- (void) setAdressePartenaire:(Partenaire *)partenaire rue:(NSString *)rue ville:(NSString *)ville codePostal:(NSString *)codePostal
{
    partenaire.adresse = @"";
    
    if (![rue isKindOfClass:[NSNull class]])
    {
        partenaire.adresse = rue;
    }
    
    if (![ville isKindOfClass:[NSNull class]] && ![partenaire.adresse isEqualToString:@""])
    {
        partenaire.adresse = [NSString stringWithFormat:@"%@, %@", partenaire.adresse, ville];
    }
    else if (![ville isKindOfClass:[NSNull class]] && [partenaire.adresse isEqualToString:@""])
    {
        partenaire.adresse = ville;
    }
    
    if (![codePostal isKindOfClass:[NSNull class]] && ![partenaire.adresse isEqualToString:@""])
    {
        partenaire.adresse = [NSString stringWithFormat:@"%@, %@", partenaire.adresse, codePostal];
    }
    else if (![codePostal isKindOfClass:[NSNull class]] && [partenaire.adresse isEqualToString:@""])
    {
        partenaire.adresse = codePostal;
    }
    
    if ([partenaire.adresse isEqualToString:@""])
    {
        partenaire.adresse = NSLocalizedString(@"TEXT_NO_DATA", @"TEXT_NO_DATA");
    }
}

@end
