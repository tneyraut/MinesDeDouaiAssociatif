//
//  MenuView.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Seconde View : Accès aux différents éléments de l'application (évènements, partenaires, BDX, données personnelles...)

#import "MenuView.h"
#import "MenuAssociationsView.h"
#import "ModificationDonneesPersonnellesView.h"
#import "EnvoiNotificationView.h"
#import "TicketMenuView.h"
#import "PartenairesView.h"
#import "EvenementsView.h"
#import "ListeLinksView.h"

#import "Association.h"
#import "User.h"
#import "Partenaire.h"
#import "Evenement.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithWebView.h"

#import "RSA.h"

#import <Parse/Parse.h>

@interface MenuView ()

@property(nonatomic, strong) EvenementModel* _evenementModel;
@property(nonatomic, strong) NSArray* _evenementsItems;

@property(nonatomic, strong) UserModel* _userModel;
@property(nonatomic, strong) NSArray* _userItems;

@property(nonatomic, strong) AssociationModel* _associationModel;
@property(nonatomic, strong) NSArray* _associationItems;

@property(nonatomic, strong) PartenaireModel* _partenaireModel;
@property(nonatomic, strong) NSArray* _partenairesItems;

@property(nonatomic, strong) LinkModel *_linkModel;
@property(nonatomic, strong) NSArray *_linkItems;

@property(nonatomic, strong) NSMutableArray *imagesArray;

@property(nonatomic, strong) NSArray *arrayTitre;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSMutableArray *BDXarray;

@end

@implementation MenuView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Menu"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonDeconnexion = [[UIBarButtonItem alloc] initWithTitle:@"Déco" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonDeconnexion)];
    
    [buttonDeconnexion setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:buttonDeconnexion];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

// Deconnexion => retour à l'IdentificationView et suppression des identifiants enregistrés dans l'application
- (void) actionListenerButtonDeconnexion
{
    [self.identificationView.sauvegarde setObject:@"" forKey:@"login"];
    [self.identificationView.sauvegarde setObject:@"" forKey:@"password"];
    
    [self.identificationView.sauvegarde synchronize];
    
    [self.navigationController popToViewController:self.identificationView animated:NO];
}

- (void) verificationIdentifiant
{
    [self.activityIndicatorView startAnimating];
    
    // Utile pour crypter password
    //NSString* passwordEncripted = [RSA encryptString:self.password publicKey:[self.identificationView.sauvegardeIdentifiants objectForKey:@"publicKey"]];
    
    if (!self._userModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._userItems = [[NSArray alloc] init];
        
        self._userModel = [[UserModel alloc] init];
        
        self._userModel.API_url = self.API_url;
        
        self._userModel.delegate = self;
    }
    [self._userModel getUser:self.login pass:self.password];
}

// Méthode liée à UserModel appelée automatiquement après téléchargement de données
- (void) getUserDownloaded:(NSArray *)items
{
    self._userItems = items;
    
    if (self._userItems.count == 0)
    {
        [self alert:@"Information" message:@"Login ou password incorrect(s)." button:@"OK"];
        
        [self.identificationView.sauvegarde setObject:@"" forKey:@"login"];
        
        [self.identificationView.sauvegarde setObject:@"" forKey:@"password"];
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController popToViewController:self.identificationView animated:YES];
    }
    else
    {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        
        // Suppression de l'utilisateur des channels Parse
        currentInstallation.channels = [[NSArray alloc] init];
        [currentInstallation saveEventually];
        
        User *user = [self._userItems objectAtIndex:0];
        
        NSDate *date = [NSDate date];
        
        NSCalendar *calendrier = [NSCalendar currentCalendar];
        
        NSDateComponents *dateComponents = [calendrier components:(NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
        
        NSInteger month = [dateComponents month];
        NSInteger year = [dateComponents year];
        
        int promotion = [user.promotion intValue];
        
        // Ajout de l'utilisateur dans le bon channel Parse
        if ((promotion - year == 3 && month >= 9) || (promotion - year == 2 && month < 9))
        {
            [currentInstallation addObject:NSLocalizedString(@"CHANNEL_NAME_FI1A", @"CHANNEL_NAME_FI1A") forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
        else if ((promotion - year == 2 && month >= 9) || (promotion - year == 1 && month < 9))
        {
            [currentInstallation addObject:NSLocalizedString(@"CHANNEL_NAME_FI2A", @"CHANNEL_NAME_FI2A") forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
        else if ((promotion - year == 1 && month >= 9) || (promotion - year == 0))
        {
            [currentInstallation addObject:NSLocalizedString(@"CHANNEL_NAME_FI3A", @"CHANNEL_NAME_FI3A") forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
        
        self.BDXarray = [[NSMutableArray alloc] init];
        
        self.imagesArray = [[NSMutableArray alloc] init];
        
        [self downloadAssociation:@"BDE"];
        
        if (user.respo_notifications_mobiles)
        {
            self.arrayTitre = [[NSArray alloc] initWithObjects:@"Evènements", @"Partenaires", @"BDE", @"BDS", @"BDA", @"BDH", @"Demande et problème informatique", @"Liens utiles", @"Données personnelles", @"Notification", nil];
        }
        else
        {
            self.arrayTitre = [[NSArray alloc] initWithObjects:@"Evènements", @"Partenaires", @"BDE", @"BDS", @"BDA", @"BDH", @"Demande et problème informatique", @"Liens utiles", @"Données personnelles", nil];
        }
    }
}

- (void) downloadEvenements
{
    if (!self._evenementModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._evenementsItems = [[NSArray alloc] init];
        
        self._evenementModel = [[EvenementModel alloc] init];
        
        self._evenementModel.API_url = self.API_url;
        
        self._evenementModel.delegate = self;
    }
    [self._evenementModel getAllEvenements];
}

// Méthode liée à EvenementModel appelée automatiquement après téléchargement de données
- (void) evenementsDownloaded:(NSArray *)items
{
    self._evenementsItems = items;
    if (items.count > 0)
    {
        EvenementsView *evenementsView = [[EvenementsView alloc] initWithStyle:UITableViewStylePlain];
        
        evenementsView.afficherImage = self.afficherImage;
        
        evenementsView.evenementsArray = self._evenementsItems;
        
        evenementsView.API_url = self.API_url;
        
        evenementsView.imagesArray = [[NSMutableArray alloc] init];
        
        for (int i=0;i<self._evenementsItems.count;i++)
        {
            Evenement *evenement = self._evenementsItems[i];
            
            if (self.afficherImage && ![evenement.image isKindOfClass:[NSNull class]] && [evenement.image rangeOfString:@"svg"].location == NSNotFound && evenement.image.length > 0 && [evenement.image rangeOfString:@"bmp"].location == NSNotFound && [evenement.image rangeOfString:@"gif"].location == NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/evenement/" stringByAppendingString:[evenement.image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                
                [evenementsView.imagesArray addObject:[UIImage imageWithData:imageData]];
            }
            else if (self.afficherImage && ![evenement.image isKindOfClass:[NSNull class]] && [evenement.image rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/evenement/" stringByAppendingString:[evenement.image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [evenementsView.imagesArray addObject:urlString];
            }
            else
            {
                [evenementsView.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_CALENDAR", @"ICON_NAME_CALENDAR")]];
            }
        }
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:evenementsView animated:YES];
    }
    else
    {
        [self.activityIndicatorView stopAnimating];
        
        [self alert:@"Information" message:@"Aucune donnée disponible." button:@"OK"];
    }
}

- (void) downloadAssociation:(NSString *)name
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._associationModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._associationItems = [[NSArray alloc] init];
        
        self._associationModel = [[AssociationModel alloc] init];
        
        self._associationModel.API_url = self.API_url;
        
        self._associationModel.delegate = self;
    }
    [self._associationModel getAssociationByName:name];
}

// Méthode liée à AssociationModel appelée automatiquement après téléchargement de données
- (void) associationsDownloaded:(NSArray *)items
{
    self._associationItems = items;
    
    if (self._associationItems.count != 0)
    {
        if (self.BDXarray.count == 0)
        {
            Association *association = self._associationItems[0];
            
            if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && association.logo.length > 0 && [association.logo rangeOfString:@"svg"].location == NSNotFound && [association.logo rangeOfString:@"bmp"].location == NSNotFound)
            {
                NSData *imageDataBDE = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
                
                [self.imagesArray addObject:[UIImage imageWithData:imageDataBDE]];
            }
            else if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && [association.logo rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [self.imagesArray addObject:urlString];
            }
            else
            {
                [self.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
            }
            
            [self.BDXarray addObject:association];
            
            [self downloadAssociation:@"BDS"];
        }
        
        else if (self.BDXarray.count == 1)
        {
            Association *association = self._associationItems[0];
            
            if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && association.logo.length > 0 && [association.logo rangeOfString:@"svg"].location == NSNotFound && [association.logo rangeOfString:@"bmp"].location == NSNotFound)
            {
                NSData *imageDataBDS = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
                
                [self.imagesArray addObject:[UIImage imageWithData:imageDataBDS]];
            }
            else if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && [association.logo rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [self.imagesArray addObject:urlString];
            }
            else
            {
                [self.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
            }
            
            [self.BDXarray addObject:association];
            
            [self downloadAssociation:@"BDA"];
        }
        
        else if (self.BDXarray.count == 2)
        {
            Association *association = self._associationItems[0];
            
            if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && association.logo.length > 0 && [association.logo rangeOfString:@"svg"].location == NSNotFound && [association.logo rangeOfString:@"bmp"].location == NSNotFound)
            {
                NSData *imageDataBDA = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
                
                [self.imagesArray addObject:[UIImage imageWithData:imageDataBDA]];
            }
            else if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && [association.logo rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [self.imagesArray addObject:urlString];
            }
            else
            {
                [self.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
            }
            
            [self.BDXarray addObject:association];
            
            [self downloadAssociation:@"BDH"];
        }
        
        else if (self.BDXarray.count == 3)
        {
            Association *association = self._associationItems[0];
            
            if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && association.logo.length > 0 && [association.logo rangeOfString:@"svg"].location == NSNotFound && [association.logo rangeOfString:@"bmp"].location == NSNotFound)
            {
                NSData *imageDataBDH = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
                
                [self.imagesArray addObject:[UIImage imageWithData:imageDataBDH]];
            }
            else if (self.afficherImage && ![association.logo isKindOfClass:[NSNull class]] && [association.logo rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[association.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [self.imagesArray addObject:urlString];
            }
            else
            {
                [self.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
            }
            
            [self.BDXarray addObject:association];
            
            [self.tableView reloadData];
            
            [self.activityIndicatorView stopAnimating];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Une erreur de connexion c'est produite..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
    }
}

- (void) downloadAllPartenaires
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._partenaireModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._partenairesItems = [[NSArray alloc] init];
        
        self._partenaireModel = [[PartenaireModel alloc] init];
        
        self._partenaireModel.API_url = self.API_url;
        
        self._partenaireModel.delegate = self;
    }
    [self._partenaireModel getAllPartenaires];
}

// Méthode liée à PartenaireModel appelée automatiquement après téléchargement de données
- (void) partenairesDownloaded:(NSArray *)items
{
    self._partenairesItems = items;
    
    if (self._partenairesItems.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucune donnée récupérée..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    PartenairesView *partenairesView = [[PartenairesView alloc] initWithStyle:UITableViewStylePlain];
    
    partenairesView.afficherImage = self.afficherImage;
    
    partenairesView.data = self._partenairesItems;
    
    partenairesView.API_url = self.API_url;
    
    partenairesView.imagesArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self._partenairesItems.count; i++)
    {
        NSArray *partenairesArray = self._partenairesItems[i];
        
        NSMutableArray *arrayImage = [[NSMutableArray alloc] init];
        
        for (int j=0;j<partenairesArray.count;j++)
        {
            Partenaire *partenaire = partenairesArray[j];
            
            if (self.afficherImage && ![partenaire.logo isKindOfClass:[NSNull class]] && [partenaire.logo rangeOfString:@"svg"].location == NSNotFound && partenaire.logo.length > 0 && [partenaire.logo rangeOfString:@"bmp"].location == NSNotFound && [partenaire.logo rangeOfString:@"gif"].location == NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/partenaire/" stringByAppendingString:[partenaire.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                
                [arrayImage addObject:[UIImage imageWithData:imageData]];
            }
            else if (self.afficherImage && ![partenaire.logo isKindOfClass:[NSNull class]] && [partenaire.logo rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/partenaire/" stringByAppendingString:[partenaire.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [arrayImage addObject:urlString];
            }
            else
            {
                [arrayImage addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_PARTENAIRE", @"ICON_NAME_PARTENAIRE")]];
            }
        }
        
        [partenairesView.imagesArray addObject:arrayImage];
    }
    
    [self.navigationController pushViewController:partenairesView animated:YES];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) downloadLinks
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._linkModel)
    {
        self._linkModel = [[LinkModel alloc] init];
        
        self._linkModel.API_url = self.API_url;
        
        self._linkModel.delegate = self;
    }
    
    [self._linkModel getAllLinks];
}

// Méthode liée à LinkModel appelée automatiquement après téléchargement de données
- (void)linksDownloaded:(NSArray *)items
{
    self._linkItems = items;
    
    NSArray *documentations = self._linkItems[0];
    
    NSArray *sitesAssociations = self._linkItems[1];
    
    NSArray *sitesUtiles = self._linkItems[2];
    
    if (documentations.count == 0 && sitesAssociations.count == 0 && sitesUtiles.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucune donnée obtenue..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    ListeLinksView *listeLinksView = [[ListeLinksView alloc] initWithStyle:UITableViewStylePlain];
    
    listeLinksView.linksArray = self._linkItems;
    
    listeLinksView.afficherImage = self.afficherImage;
    
    listeLinksView.API_url = self.API_url;
    
    [self.navigationController pushViewController:listeLinksView animated:YES];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) alert:(NSString *)titre message:(NSString *)contenu button:(NSString *)buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titre message:contenu delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

// Setting image par défaut des cell
- (void) setCellImage:(UITableViewCell *)cell i:(int)indice
{
    NSString *imageName;
    if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Evènements"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_CALENDAR", @"ICON_NAME_CALENDAR");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Partenaires"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_PARTENAIRE", @"ICON_NAME_PARTENAIRE");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"BDE"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_BDE", @"ICON_NAME_BDE");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"BDS"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_BDS", @"ICON_NAME_BDS");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"BDA"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_BDA", @"ICON_NAME_BDA");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"BDH"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_BDH", @"ICON_NAME_BDH");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Données personnelles"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_DESCRIPTION", @"ICON_NAME_DESCRIPTION");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Notification"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_NOTIFICATION", @"ICON_NAME_NOTIFICATION");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Demande et problème informatique"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_PROBLEM", @"ICON_NAME_PROBLEM");
    }
    else if ([[self.arrayTitre objectAtIndex:indice] isEqualToString:@"Liens utiles"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_WEB", @"ICON_NAME_WEB");
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithWebView class] forCellReuseIdentifier:@"cellWebView"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    if (self.demandeIdentification)
    {
        [self verificationIdentifiant];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrayTitre.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2 && indexPath.row < 5 && [self.imagesArray[indexPath.row - 2] isKindOfClass:[NSString class]])
    {
        SpecificTableViewCellWithWebView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        [cell addWebViewAndImage:self.imagesArray[indexPath.row - 2]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell.textLabel setText:[self.arrayTitre objectAtIndex:indexPath.row]];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row < 2 || indexPath.row > 5)
    {
        [self setCellImage:cell i:(int)indexPath.row];
    }
    else
    {
        [cell.imageView setImage:self.imagesArray[indexPath.row - 2]];
    }
    
    [cell.textLabel setText:[self.arrayTitre objectAtIndex:indexPath.row]];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.activityIndicatorView isAnimating])
    {
        [self.activityIndicatorView startAnimating];
        
        if ([[self.arrayTitre objectAtIndex:indexPath.row] isEqualToString:@"Données personnelles"])
        {
            ModificationDonneesPersonnellesView *modificationDonneesPersonnellesView = [[ModificationDonneesPersonnellesView alloc] initWithStyle:UITableViewStylePlain];
            
            modificationDonneesPersonnellesView.afficherImage = self.afficherImage;
            
            User* unUser = [self._userItems objectAtIndex:0];
            
            modificationDonneesPersonnellesView.user = unUser;
            
            modificationDonneesPersonnellesView.menuView = self;
            
            modificationDonneesPersonnellesView.API_url = self.API_url;
            
            if (self.afficherImage && ![unUser.avatar isKindOfClass:[NSNull class]] && [unUser.avatar rangeOfString:@"svg"].location == NSNotFound && [unUser.avatar rangeOfString:@"bmp"].location == NSNotFound && [unUser.avatar rangeOfString:@"gif"].location == NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/user/" stringByAppendingString:[unUser.avatar stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                
                modificationDonneesPersonnellesView.imageAvatar = [UIImage imageWithData:imageData];
            }
            else if (self.afficherImage && ![unUser.avatar isKindOfClass:[NSNull class]] && [unUser.avatar rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/user/" stringByAppendingString:[unUser.avatar stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                modificationDonneesPersonnellesView.imageAvatarSVG = urlString;
            }
            
            [self.activityIndicatorView stopAnimating];
            
            [self.navigationController pushViewController:modificationDonneesPersonnellesView animated:YES];
            
            return;
        }
        
        else if ([[self.arrayTitre objectAtIndex:indexPath.row] isEqualToString:@"Notification"])
        {
            EnvoiNotificationView *envoiNotificationView = [[EnvoiNotificationView alloc] initWithStyle:UITableViewStylePlain];
            
            envoiNotificationView.afficherImage = self.afficherImage;
            
            envoiNotificationView.menuView = self;
            
            envoiNotificationView.API_url = self.API_url;
            
            [self.activityIndicatorView stopAnimating];
            
            [self.navigationController pushViewController:envoiNotificationView animated:YES];
            
            return;
        }
        
        else if ([[self.arrayTitre objectAtIndex:indexPath.row] isEqualToString:@"Demande et problème informatique"])
        {
            TicketMenuView *ticketMenuView = [[TicketMenuView alloc] initWithStyle:UITableViewStylePlain];
            
            ticketMenuView.afficherImage = self.afficherImage;
            
            ticketMenuView.user = self._userItems[0];
            
            ticketMenuView.API_url = self.API_url;
            
            [self.activityIndicatorView stopAnimating];
            
            [self.navigationController pushViewController:ticketMenuView animated:YES];
            
            return;
        }
        
        else if ([[self.arrayTitre objectAtIndex:indexPath.row] isEqualToString:@"Partenaires"])
        {
            [self downloadAllPartenaires];
            
            return;
        }
        
        else if ([[self.arrayTitre objectAtIndex:indexPath.row] isEqualToString:@"Evènements"])
        {
            [self downloadEvenements];
            
            return;
        }
        
        else if ([[self.arrayTitre objectAtIndex:indexPath.row] isEqualToString:@"Liens utiles"])
        {
            [self downloadLinks];
            
            return;
        }
        
        MenuAssociationsView *menuAssociationsView = [[MenuAssociationsView alloc] initWithStyle:UITableViewStylePlain];
        
        menuAssociationsView.afficherImage = self.afficherImage;
        
        menuAssociationsView.associationParenteChoisie = self.BDXarray[indexPath.row - 2];
        
        menuAssociationsView.API_url = self.API_url;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:menuAssociationsView animated:YES];
    }
}

@end
