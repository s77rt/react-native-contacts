import type { Contact } from "./types";

export default {
	getAll(): Promise<Contact[]> {
		return Promise.reject(new Error("getAll not supported on web"));
	},
};
