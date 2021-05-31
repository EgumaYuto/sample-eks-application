import {Overview, OverviewConfig, OverviewDirectory} from "./overview/model";
import { buildCommandWithOption, TfCmd } from "./terraform/command/build";
import { spawn } from "child_process";
import { loadOverviewJson } from "./overview";
import { getCmd, getEnv } from "./arguments";
import { loadEnvVariables } from "./config/env-variables";

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

const logCommands = (command: string, path: string) => {
  const separatorSize =
    command.length > path.length ? command.length + 8 : path.length + 8;
  const separator = "=".repeat(separatorSize);
  console.log(
    `\n\n${separator}\n\nPath : ${path} \nCommand : ${command}\n\n${separator}\n`
  );
};

const execTerraform = (tfCmd: TfCmd, paths: Array<string>, overview: Overview) => {
  if (paths.length === 0) {
    return;
  }
  const path = paths[0];
  const command = buildCommandWithOption(path, tfCmd, overview.config);
  doExecTerraform(command, path, () => {
    execTerraform(tfCmd, paths.slice(1), overview);
  });
};

const doExecTerraform = (command: string, path: string, onEnd: () => void) => {
  logCommands(command, path);
  const commandWords = command.split(" ");
  const childProcess = spawn(
    commandWords[0],
    commandWords.slice(1).filter((a) => a.length !== 0),
    {
      cwd: `../${path}`,
      stdio: [process.stdin, process.stdout, process.stderr],
    }
  );
  childProcess.on("message", (data) => {
    process.stdout.write(data.toString());
  });
  childProcess.on("error", (data) => {
    process.stderr.write(data.toString());
  });
  childProcess.on("exit", onEnd);
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

const overview = loadOverviewJson();
loadEnvVariables(loadEnvVariablesFilePath(overview));
execTerraform(getCmd() as TfCmd, extractModulePaths(overview.directories), overview);
