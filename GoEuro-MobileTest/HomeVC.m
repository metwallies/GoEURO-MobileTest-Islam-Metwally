
//
//  ViewController.m
//  GoEuro-MobileTest
//
//  Created by islam metwally on 10/3/15.
//  Copyright (c) 2015 Islam Metwally. All rights reserved.
//

#import "HomeVC.h"
#import "SuggestionsManager.h"


@interface HomeVC () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    NSString *locale;
    Suggestion *start, *end;
    NSArray *suggestionsDataSource;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFieldStart;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEnd;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSuggestions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewYPosition;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    _toolBar.alpha = 0;
    _datePicker.alpha = 0;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction methods
- (IBAction)txtFieldEndtextDidChange:(id)sender {
    [SuggestionsManager GetSuggestionsWithLocale:locale
                                         andTerm:_txtFieldEnd.text
                                     withSuccess:^(NSArray *suggestions) {
                                         suggestionsDataSource = suggestions;
                                         [_tableViewSuggestions reloadData];
                                         [self animateDropDownListForTextField:_txtFieldEnd];
                                     } andFailure:^(NSError *error) {
                                         NSLog(@"%@", error.localizedDescription);
                                     }];
}
- (IBAction)txtFieldStartTextDidChange:(id)sender {
  [SuggestionsManager GetSuggestionsWithLocale:locale
                                       andTerm:_txtFieldStart.text
                                   withSuccess:^(NSArray *suggestions) {
                                       suggestionsDataSource = suggestions;
                                       [_tableViewSuggestions reloadData];
                                       [self animateDropDownListForTextField:_txtFieldStart];
                                       
                                   } andFailure:^(NSError *error) {
                                       NSLog(@"%@", error.localizedDescription);
                                   }];
}
- (IBAction)btnDoneDidTouchUpInside:(id)sender {
    _txtFieldDate.text = [_datePicker.date.description substringToIndex:10]
    ;
    [self animateDismissDatePicker];
    [self txtFieldEndEdtiting:self];
}
- (IBAction)btnSearchDidTouchUpInside:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Search is not yet implemented" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)txtFieldEndEdtiting:(id)sender {
    if (_txtFieldStart.text.length > 0 && _txtFieldEnd.text.length > 0 && _txtFieldDate.text.length > 0) {
        _btnSearch.enabled = YES;
    }
}
#pragma mark - private

-(void) animateDropDownListForTextField:(UITextField *)txtField {
    
    if (txtField == _txtFieldStart) {
        _constraintTableViewYPosition.constant = 0.0;
    }
    // 50.0 is the diffrence in Y axis between the end point of start text field and end text field
    else
        _constraintTableViewYPosition.constant = 50.0;
    
    _constraintTableViewHeight.constant = MIN(150.0, _tableViewSuggestions.contentSize.height);
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                     } completion:nil];
}
-(void) animateCloseDropDownList {
    _constraintTableViewHeight.constant = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void) animateShowDatePicker {
    [UIView animateWithDuration:0.5
                     animations:^{
                         _datePicker.alpha = 1;
                         _toolBar.alpha = 1;
                     }];
}

-(void) animateDismissDatePicker{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _datePicker.alpha = 0;
                         _toolBar.alpha = 0;
                     }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return suggestionsDataSource.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //setting data
    Suggestion *tmpSuggestion = [suggestionsDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tmpSuggestion.name;
    cell.detailTextLabel.text = tmpSuggestion.fullName;
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_txtFieldEnd isFirstResponder]) {
        end = [suggestionsDataSource objectAtIndex:indexPath.row];
        _txtFieldEnd.text = end.fullName;
        [self animateCloseDropDownList];
        [self textFieldShouldReturn:_txtFieldEnd];
        
    } else if ([_txtFieldStart isFirstResponder]){
        start = [suggestionsDataSource objectAtIndex:indexPath.row];
        _txtFieldStart.text = start.fullName;
        [self animateCloseDropDownList];
        [self textFieldShouldReturn:_txtFieldStart];
    }
 }


#pragma mark - CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *userLocation = [locations lastObject];
    NSDictionary *userDict = [[NSDictionary alloc]
                              initWithObjects:@[@(userLocation.coordinate.latitude), @(userLocation.coordinate.longitude)] forKeys:@[@"latitude", @"longitude"]];
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:@"userLocation"];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error while getting core location : %@",[error description]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if (textField == _txtFieldEnd || textField == _txtFieldStart) {
        [self animateCloseDropDownList];
    }
    return YES;
}

-(void)
textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtFieldDate) {
        [textField resignFirstResponder];
        [self animateShowDatePicker];
    }
}

@end
