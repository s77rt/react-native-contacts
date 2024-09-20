type LabeledValue = {
	label: string;
	value: string;
};

type PhoneNumbers = LabeledValue[];
type EmailAddresses = LabeledValue[];

export type Contact = {
	firstName: string | null;
	lastName: string | null;
	phoneNumbers: PhoneNumbers;
	emailAddresses: EmailAddresses;
};
