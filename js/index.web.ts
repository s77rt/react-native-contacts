import type { Contacts } from "./types";

export default {
	getAll(): Promise<Contacts> {
		return Promise.reject(new Error("getAll not supported on web"));
	},
};
