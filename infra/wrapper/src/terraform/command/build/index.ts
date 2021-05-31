import { OverviewConfig } from "../../../overview/model";

export type TfCmd = "init" | "plan" | "apply" | "destroy";

export const buildCommandWithOption = (
  path: string,
  tfCmd: TfCmd,
  config: OverviewConfig
): string => {
  switch (tfCmd) {
    case "init":
      return buildInitCommandWithOption(path, config);
    case "plan":
    case "apply":
    case "destroy":
      return buildExecuteCommandWithOption(path, tfCmd, config);
    default:
      throw new Error(`サポートできていない tf cmd: ${tfCmd}`);
  }
};

const buildInitCommandWithOption = (
  path: string,
  config: OverviewConfig
): string => {
  const options =
    `-backend-config key=state/${
      path.endsWith("/") ? path.slice(0, -1) : path
    }.tfstate` +
    ` -backend-config bucket=sample-ecs-application-tfstate` + // TODO 外部から取得する
    ` -backend-config region=ap-northeast-1`; // TODO 外部から取得する
  return `terraform init ${options}`;
};

const buildExecuteCommandWithOption = (
  path: string,
  tfCmd: TfCmd,
  _config: OverviewConfig
): string => {
  return `terraform ${tfCmd}`;
};
