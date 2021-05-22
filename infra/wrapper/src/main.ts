import { Overview, OverviewDirectory } from "./model";
import * as fs from "fs";
import { argv } from "./arguments";
import { buildCommand, TfCmd } from "./terraform-executor";
import { spawn } from "child_process";
import {loadDirectoriesJson} from "./file-loader";

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

const doSpawnTerraformCmd = (
  tfCmd: TfCmd,
  paths: Array<string>,
  now: number
) => {
  const path = paths[now];
  const command = buildCommand(path, tfCmd, wrapper.config);
  console.log(
    `\n${"=".repeat(command.length)}\n\n${command}\n\n${"=".repeat(
      command.length
    )}\n`
  );
  const com = command.split(" ");
  const proc = spawn(com[0], com.slice(1).filter(a => a.length !== 0), { cwd: `../${path}` });
  proc.stdout.on("data", (data) => {
    process.stdout.write(data.toString());
  });
  proc.stderr.on("data", (data) => {
    process.stdout.write(data.toString());
  });
  proc.stderr.on("end", () => {
    if (now < paths.length - 1) {
      doSpawnTerraformCmd(tfCmd, paths, now + 1);
    }
  });
};

const wrapper = loadDirectoriesJson();
doSpawnTerraformCmd(argv["tf_cmd"] as TfCmd, extractModulePaths(wrapper.directories), 0);
