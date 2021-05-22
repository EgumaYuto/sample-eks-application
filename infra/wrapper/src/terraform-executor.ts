import { Overview, OverviewConfig } from "./model";
import {loadEnvFile} from "./file-loader";

export type TfCmd = "init" | "plan" | "apply" | "destroy";

export const buildCommand = (
  path: string,
  tfCmd: TfCmd,
  config: OverviewConfig
): string => {
  switch (tfCmd) {
    case "init":
      return buildInitCommand(path, config);
    case "plan":
    case "apply":
    case "destroy":
      return buildExecuteCommand(path, tfCmd, config);
    default:
      throw new Error(`サポートできていない tf cmd: ${tfCmd}`);
  }
};

const buildInitCommand = (path: string, config: OverviewConfig): string => {
  const options =
    `-backend-config key=state/${
      path.endsWith("/") ? path.slice(0, -1) : path
    }.tfstate` +
    ` -backend-config bucket=sample-ecs-application-tfstate` + // TODO 外部から取得する
    ` -backend-config region=ap-northeast-1`; // TODO 外部から取得する
  return `terraform init ${options}`;
};

const buildExecuteCommand = (path: string, tfCmd: TfCmd, config: OverviewConfig): string => {
  const envVariables = loadEnvFile(config);
  Object.entries(envVariables).forEach(entry => {
    if (entry[1] instanceof Array) {
      // このようなフォーマットにする : ["ap-northeast-1a","ap-northeast-1c","ap-northeast-1d"]
      process.env[`TF_VAR_${entry[0]}`] = `[${entry[1].map(item => '"' + item + '"').join(",")}]`
      console.log(process.env[`TF_VAR_${entry[0]}`])
    } else {
      process.env[`TF_VAR_${entry[0]}`] = entry[1]
    }
  });
  return `terraform ${tfCmd}`
}