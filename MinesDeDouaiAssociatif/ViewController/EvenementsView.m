//
//  EvenementsView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 16/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Liste des évènements

#import "EvenementsView.h"
#import "AssociationView.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithWebView.h"

#import "Evenement.h"

@interface EvenementsView ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSMutableArray *sectionArray;

@property(nonatomic, strong) NSMutableArray *tailleSection;

@end

@implementation EvenementsView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Evènements"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Evènements" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) addSectionMois:(NSString *)mois annee:(NSString *)annee
{
    if ([mois isEqualToString:@"01"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Janvier %@", annee]];
    }
    else if ([mois isEqualToString:@"02"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Février %@", annee]];
    }
    else if ([mois isEqualToString:@"03"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Mars %@", annee]];
    }
    else if ([mois isEqualToString:@"04"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Avril %@", annee]];
    }
    else if ([mois isEqualToString:@"05"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Mai %@", annee]];
    }
    else if ([mois isEqualToString:@"06"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Juin %@", annee]];
    }
    else if ([mois isEqualToString:@"07"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Juillet %@", annee]];
    }
    else if ([mois isEqualToString:@"08"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Août %@", annee]];
    }
    else if ([mois isEqualToString:@"09"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Septembre %@", annee]];
    }
    else if ([mois isEqualToString:@"10"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Octobre %@", annee]];
    }
    else if ([mois isEqualToString:@"11"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Novembre %@", annee]];
    }
    else if ([mois isEqualToString:@"12"])
    {
        [self.sectionArray addObject:[NSString stringWithFormat:@"Décembre %@", annee]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellWebView"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    if (self.evenementsArray.count > 0)
    {
        self.sectionArray = [[NSMutableArray alloc] init];
        
        self.tailleSection = [[NSMutableArray alloc] init];
        
        Evenement *event = self.evenementsArray[0];
        
        NSString *mois = [event.start substringWithRange:NSMakeRange(5, 2)];
        
        NSString *annee = [event.start substringWithRange:NSMakeRange(0, 4)];
        
        int taille = 1;
        
        if (self.evenementsArray.count == 1)
        {
            [self addSectionMois:mois annee:annee];
            
            [self.tailleSection addObject:[NSString stringWithFormat:@"%d", taille]];
        }
        
        for (int i=1;i<self.evenementsArray.count;i++)
        {
            Evenement *evenement = self.evenementsArray[i];
            
            NSString *month = [evenement.start substringWithRange:NSMakeRange(5, 2)];
            
            NSString *year = [evenement.start substringWithRange:NSMakeRange(0, 4)];
            
            if ([month isEqualToString:mois] && [year isEqualToString:annee])
            {
                taille++;
            }
            else
            {
                [self addSectionMois:mois annee:annee];
                
                [self.tailleSection addObject:[NSString stringWithFormat:@"%d", taille]];
                
                taille = 1;
                mois = month;
                annee = year;
            }
            
            if (i == self.evenementsArray.count - 1)
            {
                [self addSectionMois:mois annee:annee];
                
                [self.tailleSection addObject:[NSString stringWithFormat:@"%d", taille]];
            }
        }
        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tailleSection[section] intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int indice = (int)indexPath.row;
    
    for (int i=0;i<(int)indexPath.section;i++)
    {
        indice += [self.tailleSection[i] intValue];
    }
    
    Evenement *evenement = self.evenementsArray[indice];
    
    if ([self.imagesArray[indice] isKindOfClass:[NSString class]])
    {
        SpecificTableViewCellWithWebView *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell.textLabel setText:evenement.title];
        
        [cell addWebViewAndImage:self.imagesArray[indice]];
    }
    
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setText:evenement.title];
    
    [cell.imageView setImage:self.imagesArray[indice]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    int indice = (int)indexPath.row;
    
    for (int i=0;i<(int)indexPath.section;i++)
    {
        indice += [self.tailleSection[i] intValue];
    }
    
    Evenement *evenement = self.evenementsArray[indice];
    
    UIImage *image = self.imagesArray[indice];
    
    AssociationView *associationView = [[AssociationView alloc] initWithStyle:UITableViewStylePlain];
    
    associationView.afficherImage = self.afficherImage;
    
    associationView.data = [[NSArray alloc] initWithObjects:evenement, nil];
    
    associationView.imagesArray = [[NSMutableArray alloc] initWithObjects:image, nil];
    
    associationView.sousMenuChoisi = @"Evènements";
    
    associationView.API_url = self.API_url;
    
    [self.navigationController pushViewController:associationView animated:YES];
    
    [self.activityIndicatorView stopAnimating];
}

@end
