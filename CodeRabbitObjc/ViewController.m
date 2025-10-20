//
//  ViewController.m
//  CodeRabbitObjc
//
//  Created by Berkay Çetinkaya on 20.10.2025.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray<NSString *> *countries;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countries = @[@"Türkiye", @"Almanya", @"ABD", @"İngiltere", @"Japonya"];

    // Resolve storyboard views by tag if not connected via Interface Builder
    if (!self.nameTextField) {
        self.nameTextField = (UITextField *)[self.view viewWithTag:100];
    }
    if (!self.emailTextField) {
        self.emailTextField = (UITextField *)[self.view viewWithTag:101];
    }
    if (!self.genderSegmentedControl) {
        self.genderSegmentedControl = (UISegmentedControl *)[self.view viewWithTag:102];
    }
    if (!self.birthDatePicker) {
        self.birthDatePicker = (UIDatePicker *)[self.view viewWithTag:103];
    }
    if (!self.termsSwitch) {
        self.termsSwitch = (UISwitch *)[self.view viewWithTag:104];
    }
    if (!self.countryPickerView) {
        self.countryPickerView = (UIPickerView *)[self.view viewWithTag:105];
    }
    if (!self.summaryLabel) {
        self.summaryLabel = (UILabel *)[self.view viewWithTag:107];
    }

    // Wire delegates
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.countryPickerView.delegate = self;
    self.countryPickerView.dataSource = self;

    // Configure date picker maximum (no future dates)
    self.birthDatePicker.maximumDate = [NSDate date];

    // Accessibility identifiers (useful for UI tests)
    self.nameTextField.accessibilityIdentifier = @"nameTextField";
    self.emailTextField.accessibilityIdentifier = @"emailTextField";
    self.genderSegmentedControl.accessibilityIdentifier = @"genderSegmentedControl";
    self.birthDatePicker.accessibilityIdentifier = @"birthDatePicker";
    self.termsSwitch.accessibilityIdentifier = @"termsSwitch";
    self.countryPickerView.accessibilityIdentifier = @"countryPickerView";
    self.summaryLabel.accessibilityIdentifier = @"summaryLabel";

    // Bind submit button action
    UIButton *submitButton = (UIButton *)[self.view viewWithTag:106];
    [submitButton addTarget:self action:@selector(submitTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - IBActions

- (IBAction)submitTapped:(id)sender {
    [self.view endEditing:YES];

    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger genderIndex = self.genderSegmentedControl.selectedSegmentIndex;
    NSDate *birthDate = self.birthDatePicker.date;
    BOOL accepted = self.termsSwitch.isOn;

    if (name.length == 0) {
        [self showAlertWithTitle:@"Hata" message:@"Lütfen ad soyad girin."];
        return;
    }
    if (![self isValidEmail:email]) {
        [self showAlertWithTitle:@"Hata" message:@"Lütfen geçerli bir e-posta girin."];
        return;
    }
    if (!accepted) {
        [self showAlertWithTitle:@"Hata" message:@"Koşulları kabul etmelisiniz."];
        return;
    }

    NSString *gender = @"Belirtilmedi";
    if (genderIndex == 0) gender = @"Kadın";
    else if (genderIndex == 1) gender = @"Erkek";
    else if (genderIndex == 2) gender = @"Diğer";

    NSInteger selectedRow = [self.countryPickerView selectedRowInComponent:0];
    NSString *country = self.countries.count > 0 ? self.countries[selectedRow] : @"-";

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.locale = [NSLocale localeWithLocaleIdentifier:@"tr_TR"];
    NSString *birthText = [df stringFromDate:birthDate];

    self.summaryLabel.text = [NSString stringWithFormat:@"Ad: %@\nE-posta: %@\nCinsiyet: %@\nDoğum: %@\nÜlke: %@\nKoşullar: %@",
                              name, email, gender, birthText, country, accepted ? @"Kabul" : @"Red"];
}

#pragma mark - Helpers

- (BOOL)isValidEmail:(NSString *)email {
    if (email.length == 0) return NO;
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:email];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countries.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.countries[row];
}


@end
