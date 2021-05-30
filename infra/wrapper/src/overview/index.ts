import { Overview } from "./model";
import fs from "fs";
import { getOverviewJsonFilePath } from "../arguments";

export const loadOverviewJson = (): Overview => {
  return JSON.parse(fs.readFileSync(getOverviewJsonFilePath(), "utf-8"));
};
