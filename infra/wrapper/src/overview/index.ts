import { Overview } from "./model";
import fs from "fs";
import YAML from "yaml";

export const loadOverviewFile = (filePath: string): Overview => {
  if (filePath.endsWith("json")) {
    return loadOverviewJson(filePath);
  }
  if (filePath.endsWith("yaml") || filePath.endsWith("yml")) {
    return loadOverviewYaml(filePath);
  }
  throw new Error(`Unresolved file extention. filePath : ${filePath}`);
};

const loadOverviewJson = (filePath: string): Overview => {
  return JSON.parse(fs.readFileSync(filePath, "utf-8"));
};

const loadOverviewYaml = (filePath: string): Overview => {
  return YAML.parse(fs.readFileSync(filePath, "utf-8"));
};
