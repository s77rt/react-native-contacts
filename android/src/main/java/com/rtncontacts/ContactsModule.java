package com.rtncontacts;

import android.content.ContentResolver;
import android.content.res.Resources;
import android.database.Cursor;
import android.provider.ContactsContract;
import androidx.annotation.NonNull;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.rtncontacts.NativeRTNContactsSpec;
import java.util.HashMap;
import java.util.Map;

public class ContactsModule extends NativeRTNContactsSpec {

  public static String NAME = "RTNContacts";

  private ReactApplicationContext reactContext;

  ContactsModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @Override
  public void getAll(ReadableArray keys, Promise promise) {
    WritableArray contacts = Arguments.createArray();

    Resources res = reactContext.getResources();
    ContentResolver cr = reactContext.getContentResolver();
    Cursor cursor = cr.query(ContactsContract.Data.CONTENT_URI,
                             new String[] {
                                 ContactsContract.Data.MIMETYPE,
                                 ContactsContract.Data.CONTACT_ID,
                                 ContactsContract.Data.DATA1,
                                 ContactsContract.Data.DATA2,
                                 ContactsContract.Data.DATA3,
                             },
                             ContactsContract.Data.MIMETYPE + " IN ("
                                 + "?, ".repeat(keys.size() - 1) + "?)",
                             keys.toArrayList().toArray(new String[0]),
                             ContactsContract.Data.CONTACT_ID + " ASC");

    if (cursor != null) {
      long contactID = 0L;

      WritableMap contact = null;
      WritableArray phoneNumbers = null;
      WritableArray emailAddresses = null;

      boolean hasNext = cursor.moveToNext();
      while (hasNext) {
        if (contactID == 0L) {
          contactID = cursor.getLong(
              cursor.getColumnIndex(ContactsContract.Data.CONTACT_ID));
        }

        if (contact == null) {
          contact = Arguments.createMap();
        }

        String mimeType = cursor.getString(
            cursor.getColumnIndex(ContactsContract.Data.MIMETYPE));
        switch (mimeType) {
        case ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE:
          contact.putString("firstName", cursor.getString(cursor.getColumnIndex(
                                             ContactsContract.Data.DATA2)));
          contact.putString("lastName", cursor.getString(cursor.getColumnIndex(
                                            ContactsContract.Data.DATA3)));
          break;
        case ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE:
          if (phoneNumbers == null) {
            phoneNumbers = Arguments.createArray();
          }
          int phoneType =
              cursor.getInt(cursor.getColumnIndex(ContactsContract.Data.DATA2));
          String phoneCustomLabel = cursor.getString(
              cursor.getColumnIndex(ContactsContract.Data.DATA3));
          WritableMap phoneNumber = Arguments.createMap();
          phoneNumber.putString(
              "label", ContactsContract.CommonDataKinds.Phone
                           .getTypeLabel(res, phoneType, phoneCustomLabel)
                           .toString());
          phoneNumber.putString("value", cursor.getString(cursor.getColumnIndex(
                                             ContactsContract.Data.DATA1)));
          phoneNumbers.pushMap(phoneNumber);
          break;
        case ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE:
          if (emailAddresses == null) {
            emailAddresses = Arguments.createArray();
          }
          int emailType =
              cursor.getInt(cursor.getColumnIndex(ContactsContract.Data.DATA2));
          String emailCustomLabel = cursor.getString(
              cursor.getColumnIndex(ContactsContract.Data.DATA3));
          WritableMap emailAddress = Arguments.createMap();
          emailAddress.putString(
              "label", ContactsContract.CommonDataKinds.Email
                           .getTypeLabel(res, emailType, emailCustomLabel)
                           .toString());
          emailAddress.putString(
              "value", cursor.getString(
                           cursor.getColumnIndex(ContactsContract.Data.DATA1)));
          emailAddresses.pushMap(emailAddress);
          break;
        }

        hasNext = cursor.moveToNext();
        long nextContactID = hasNext ? cursor.getLong(cursor.getColumnIndex(
                                           ContactsContract.Data.CONTACT_ID))
                                     : 0L;

        if (nextContactID != contactID) {
          if (phoneNumbers != null) {
            contact.putArray("phoneNumbers", phoneNumbers);
            phoneNumbers = null;
          }
          if (emailAddresses != null) {
            contact.putArray("emailAddresses", emailAddresses);
            emailAddresses = null;
          }

          contacts.pushMap(contact);
          contact = null;
        }

        contactID = nextContactID;
      }

      cursor.close();
    }

    promise.resolve(contacts);
  }
}
