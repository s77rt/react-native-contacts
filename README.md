# @s77rt/react-native-contacts

A React Native module to get contacts.

## Installation

```bash
npm install @s77rt/react-native-contacts
```

### Android

Add `android.permission.READ_CONTACTS` to `AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

### iOS

Add `NSContactsUsageDescription` to `Info.plist`

```xml
<key>NSContactsUsageDescription</key>
<string>[USAGE_DESCRIPTION]</string>
```

## Usage

Request permission

```jsx
import { request, PERMISSIONS } from "react-native-permissions";

// Android
request(PERMISSIONS.ANDROID.READ_CONTACTS).then((result) => {
  /* … */
});

// iOS
request(PERMISSIONS.IOS.CONTACTS).then((result) => {
  /* … */
});
```

Use `Contacts`

```jsx
import Contacts from "@s77rt/react-native-contacts";

Contacts.getAll(["firstName", "lastName", "phoneNumbers", "emailAddresses"])
  .then((contacts) => {
    console.log(contacts);
  })
  .catch((error) => {
    console.error(error);
  });
```

## Methods

|   Name   |               Arguments                |                    Description                    |
| :------: | :------------------------------------: | :-----------------------------------------------: |
| `getAll` | `fields: NonEmptyArray<keyof Contact>` | Get all contacts. Returns a `Promise<Contact[]>`. |

## License

[MIT](LICENSE)
