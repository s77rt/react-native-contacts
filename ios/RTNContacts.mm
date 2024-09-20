#import "RTNContacts.h"

#import <Contacts/Contacts.h>

@implementation RTNContacts

RCT_EXPORT_MODULE()
- (void)getAll:(RCTPromiseResolveBlock)resolve
        reject:(RCTPromiseRejectBlock)reject {
  CNContactStore *store = [[CNContactStore alloc] init];
  CNContactFetchRequest *fetchRequest =
      [[CNContactFetchRequest alloc] initWithKeysToFetch:@[
        CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey
      ]];
  NSError *error;
  NSMutableArray *contacts = [NSMutableArray array];

  BOOL success = [store
      enumerateContactsWithFetchRequest:fetchRequest
                                  error:&error
                             usingBlock:^(CNContact *__nonnull contact,
                                          BOOL *__nonnull stop) {
                               if (error) {
                                 *stop = YES;
                                 return;
                               }

                               NSMutableArray *phoneNumbers =
                                   [NSMutableArray array];
                               for (CNLabeledValue<CNPhoneNumber *>
                                        *phoneNumber in contact.phoneNumbers) {
                                 [phoneNumbers addObject:@{
                                   @"label" : phoneNumber.label ?: @"",
                                   @"value" : phoneNumber.value.stringValue,
                                 }];
                               }

                               NSMutableArray *emailAddresses =
                                   [NSMutableArray array];
                               for (CNLabeledValue<NSString *> *emailAddress in
                                        contact.emailAddresses) {

                                 [emailAddresses addObject:@{
                                   @"label" : emailAddress.label ?: @"",
                                   @"value" : emailAddress.value,
                                 }];
                               }

                               [contacts addObject:@{
                                 @"firstName" : contact.givenName,
                                 @"lastName" : contact.familyName,
                                 @"phoneNumbers" : phoneNumbers,
                                 @"emailAddresses" : emailAddresses,
                               }];
                             }];

  if (!success) {
    reject(
        error ? [@(error.code) stringValue] : @"Unknown",
        [NSString
            stringWithFormat:@"Error: %@ - Reason: %@",
                             error ? error.localizedDescription : @"Unknown",
                             error ? error.localizedFailureReason : @"Unknown"],
        error);
    return;
  }

  resolve(contacts);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeRTNContactsSpecJSI>(params);
}

@end