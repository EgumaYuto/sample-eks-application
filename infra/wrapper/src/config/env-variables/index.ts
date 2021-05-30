import fs from "fs";

export const loadEnvVariables = (envFilePath: string): object => {
  const envVariables = readEnvVariables(envFilePath);
  storeEnvVariables(envVariables);
  return envVariables;
};

const readEnvVariables = (envFilePath: string): object => {
  // TODO "../" は外部から受け取る
  return JSON.parse(fs.readFileSync(`../${envFilePath}`, "utf-8"));
};

const storeEnvVariables = (envVariables: object): void => {
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
