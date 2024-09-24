export type NonEmptyArray<T> = [T, ...T[]];

type LabeledValue = {
	label: string | null;
	value: string;
};

type PhoneNumbers = LabeledValue[];
type EmailAddresses = LabeledValue[];

export type Contact = {
	firstName?: string | null;
	lastName?: string | null;
	phoneNumbers?: PhoneNumbers;
	emailAddresses?: EmailAddresses;
	thumbnail?: string | null;
};
