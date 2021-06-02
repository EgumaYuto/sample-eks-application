import { Overview, OverviewDirectory } from "./overview/model";
import { TfCmd } from "./terraform/command/build";
import { getArguments } from "./arguments";
import { loadEnvVariables } from "./config/env-variables";
import { execTerraform } from "./terraform/command/execute";
import { loadOverviewFile } from "./overview";

export const extractModulePaths = (
  directories: Array<OverviewDirectory>,
  paths: Array<string>
): Array<string> => {
  if (paths.includes("ALL")) {
    return doExtractModulePaths("", directories);
  }
  return doExtractModulePaths("", directories).filter((directory) =>
    paths.includes(directory)
  );
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

const loadEnvVariablesFilePath = (overview: Overview, env: string): string => {
  const variables = overview.config.env_variables.find(
    (variables) => variables.name === env
  );
  if (variables) {
    return variables.file_path;
  }
  throw new Error(`env に対応した変数が設定されていません, env: ${env}`);
};

const cliArguments = getArguments();
if (cliArguments.command === "execute") {
  const options = cliArguments.executeOption;
  const overview = loadOverviewFile(options.overviewFilePath);
  const envVariables = loadEnvVariables(
    loadEnvVariablesFilePath(overview, options.env)
  );
  const modulePaths = extractModulePaths(
    overview.directories,
    options.targetPath.split(",")
  );
  let tfCmd = options.command;
  execTerraform(
    tfCmd as TfCmd,
    tfCmd.startsWith("destroy") ? modulePaths.reverse() : modulePaths,
    envVariables
  );
}
