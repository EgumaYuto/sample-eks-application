export type TfCmd = "init" | "plan" | "apply" | "destroy";

export const buildCommandWithOption = (
  path: string,
  tfCmd: TfCmd,
  envVariables: object
): string => {
  switch (tfCmd) {
    case "init":
      return buildInitCommandWithOption(path, envVariables);
    case "plan":
    case "apply":
    case "destroy":
      return buildExecuteCommandWithOption(path, tfCmd);
    default:
      throw new Error(`サポートできていない tf cmd: ${tfCmd}`);
  }
};

const buildInitCommandWithOption = (
  path: string,
  _envVariables: object
): string => {
  // TODO S3じゃない場合との兼ね合い
  const options =
    `-backend-config key=state/${
      path.endsWith("/") ? path.slice(0, -1) : path
    }.tfstate` +
    ` -backend-config bucket=sample-ecs-application-tfstate` +
    ` -backend-config region=ap-northeast-1`;
  return `terraform init ${options}`;
};

const buildExecuteCommandWithOption = (path: string, tfCmd: TfCmd): string => {
  return `terraform ${tfCmd}`;
};
