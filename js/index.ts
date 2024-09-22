import type { Contact, NonEmptyArray } from "./types";

export default {
	getAll(fields: NonEmptyArray<keyof Contact>): Promise<Contact[]> {
		return Promise.reject(new Error("getAll not supported on web"));
	},
};
