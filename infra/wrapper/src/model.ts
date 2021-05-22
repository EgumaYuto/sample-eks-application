export interface Overview {
  config: OverviewConfig;
  directories: Array<OverviewDirectory>;
}

export interface OverviewConfig {
  backend: OverviewConfigTfState;
  env_variables: Array<OverviewConfigEnvVariables>;
}

export interface OverviewConfigEnvVariables {
  name: string;
  file_path: string;
}

export interface OverviewConfigTfState {
  type: "S3" | "Local";
  base_path: string;
}

export interface OverviewDirectory {
  path: string;
  type: "directory" | "module" | undefined;
  directories: Array<OverviewDirectory> | undefined;
}