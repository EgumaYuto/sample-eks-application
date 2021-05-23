import { Overview, OverviewConfig, OverviewDirectory } from "./model";
import * as fs from "fs";
import { argv } from "./arguments";
import { buildCommandWithOption, TfCmd } from "./terraform-executor";
import { spawn } from "child_process";
import { loadOverviewJson, loadEnvFile } from "./file-loader";

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

const execTerraform = (tfCmd: TfCmd, paths: Array<string>) => {
  if (paths.length === 0) {
    return;
  }
  const path = paths[0];
  const command = buildCommandWithOption(path, tfCmd, overview.config);
  doExecTerraform(command, path, () => {
    execTerraform(tfCmd, paths.slice(1));
  });
};

const doExecTerraform = (command: string, path: string, onEnd: () => void) => {
  logCommands(command, path);
  const commandWords = command.split(" ");
  const childProcess = spawn(
    commandWords[0],
    commandWords.slice(1).filter((a) => a.length !== 0),
    { cwd: `../${path}` }
  );
  childProcess.stdout.on("data", (data) => {
    process.stdout.write(data.toString());
  });
  childProcess.stderr.on("data", (data) => {
    process.stdout.write(data.toString());
  });
  childProcess.on("end", onEnd);
};

const loadEnvVariables = (config: OverviewConfig) => {
  const envVariables = loadEnvFile(config);
  Object.entries(envVariables).forEach((entry) => {
    if (entry[1] instanceof Array) {
      process.env[`TF_VAR_${entry[0]}`] = `[${entry[1]
        .map((item) => '"' + item + '"')
        .join(",")}]`;
    } else {
      process.env[`TF_VAR_${entry[0]}`] = entry[1];
    }
  });
};

const overview = loadOverviewJson();
loadEnvVariables(overview.config);
execTerraform(
  argv["tf_cmd"] as TfCmd,
  extractModulePaths(overview.directories)
);
