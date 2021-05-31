import { buildCommandWithOption, TfCmd } from "../build";
import { Overview } from "../../../overview/model";
import { spawn } from "child_process";

export const execTerraform = (
  tfCmd: TfCmd,
  paths: Array<string>,
  overview: Overview
) => {
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

const logCommands = (command: string, path: string) => {
  const separatorSize =
    command.length > path.length ? command.length + 8 : path.length + 8;
  const separator = "=".repeat(separatorSize);
  console.log(
    `\n\n${separator}\n\nPath : ${path} \nCommand : ${command}\n\n${separator}\n`
  );
};
