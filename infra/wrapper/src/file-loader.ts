import { Overview, OverviewConfig } from "./model";
import fs from "fs";
import { getEnv, getOverviewJsonFilePath } from "./arguments";

export const loadOverviewJson = (): Overview => {
  return JSON.parse(fs.readFileSync(getOverviewJsonFilePath(), "utf-8"));
};

export const loadEnvFile = (config: OverviewConfig): object => {
  return JSON.parse(
    fs.readFileSync("../" + loadEnvFilePath(getEnv(), config), "utf-8")
  );
};

const loadEnvFilePath = (env: string, config: OverviewConfig): string => {
  const variables = config.env_variables.find(
    (variables) => variables.name === env
  );
  if (variables) {
    return variables.file_path;
  }
  throw new Error(`env に対応した変数が設定されていません, env: ${env}`);
};
