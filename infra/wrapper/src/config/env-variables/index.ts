import { OverviewConfig } from "../../overview/model";
import fs from "fs";
import { getEnv } from "../../arguments";

export const loadEnvVariablesFile = (config: OverviewConfig): object => {
  return JSON.parse(
    fs.readFileSync("../" + loadEnvVariablesFilePath(getEnv(), config), "utf-8")
  );
};

const loadEnvVariablesFilePath = (
  env: string,
  config: OverviewConfig
): string => {
  const variables = config.env_variables.find(
    (variables) => variables.name === env
  );
  if (variables) {
    return variables.file_path;
  }
  throw new Error(`env に対応した変数が設定されていません, env: ${env}`);
};
