import type { Contact, NonEmptyArray } from "./types";
import NativeRTNContacts from "./NativeRTNContacts";

const FIELD_TO_MIMETYPE_MAP: Record<keyof Contact, string> = {
	firstName: "vnd.android.cursor.item/name", // ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE
	lastName: "vnd.android.cursor.item/name", // ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE
	phoneNumbers: "vnd.android.cursor.item/phone_v2", // ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE
	emailAddresses: "vnd.android.cursor.item/email_v2", // ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE
} as const;

export default {
	getAll(fields: NonEmptyArray<keyof Contact>): Promise<Contact[]> {
		return NativeRTNContacts.getAll(
			fields.map((field) => FIELD_TO_MIMETYPE_MAP[field])
		);
	},
};
