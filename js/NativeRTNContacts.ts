import { TurboModule, TurboModuleRegistry } from "react-native";
import type { Contacts } from "./types";

export interface Spec extends TurboModule {
	getAll(): Promise<Contacts>;
}

export default TurboModuleRegistry.getEnforcing<Spec>("RTNContacts");
