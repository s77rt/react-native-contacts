import type { Contact, NonEmptyArray } from "./types";
import NativeRTNContacts from "./NativeRTNContacts";

const FIELD_TO_KEY_MAP: Record<keyof Contact, string> = {
	firstName: "givenName", // CNContactGivenNameKey
	lastName: "familyName", // CNContactFamilyNameKey
	phoneNumbers: "phoneNumbers", // CNContactPhoneNumbersKey
	emailAddresses: "emailAddresses", // CNContactEmailAddressesKey
	thumbnail: "thumbnailImageData", // CNContactThumbnailImageDataKey
} as const;

export default {
	getAll(fields: NonEmptyArray<keyof Contact>): Promise<Contact[]> {
		return NativeRTNContacts.getAll(
			fields.map((field) => FIELD_TO_KEY_MAP[field])
		);
	},
};
