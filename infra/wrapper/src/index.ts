import { Overview, OverviewDirectory } from "./overview/model";
import { TfCmd } from "./terraform/command/build";
import { getCmd, getEnv } from "./arguments";
import { loadEnvVariables } from "./config/env-variables";
import { execTerraform } from "./terraform/command/execute";
import { loadOverviewFile } from "./overview";

export const extractModulePaths = (
  directories: Array<OverviewDirectory>
): Array<string> => {
  return doExtractModulePaths("", directories);
};

const doExtractModulePaths = (
  parentPath: string,
  directories: Array<OverviewDirectory>
): Array<string> => {
  return directories.flatMap((module) => {
    const currentPath =
      parentPath === "" ? module.path : `${parentPath}/${module.path}`;
    if (!module.directories || module.type == "module") {
      return [currentPath];
    } else {
      return doExtractModulePaths(currentPath, module.directories);
    }
  });
};

const loadEnvVariablesFilePath = (overview: Overview): string => {
  const env = getEnv();
  const variables = overview.config.env_variables.find(
    (variables) => variables.name === env
  );
  if (variables) {
    return variables.file_path;
  }
  throw new Error(`env に対応した変数が設定されていません, env: ${env}`);
};

const overview = loadOverviewFile();
const envVariables = loadEnvVariables(loadEnvVariablesFilePath(overview));
execTerraform(
  getCmd() as TfCmd,
  extractModulePaths(overview.directories),
  overview
);
