import { TurboModule, TurboModuleRegistry } from "react-native";
import type { Contact } from "./types";

export interface Spec extends TurboModule {
	getAll(): Promise<Contact[]>;
}

export default TurboModuleRegistry.getEnforcing<Spec>("RTNContacts");
