import yargs from "yargs";

const argv = yargs
  .command("execute", "Execute terraform", (yargs) => {
    return yargs
      .option("cmd", {
        alias: "c",
        type: "string",
        description:
          "(Required) terraform command (init, plan, apply and so on...)",
      })
      .option("env", {
        alias: "e",
        type: "string",
        description: "(Required) Execute environment",
      })
      .option("overview", {
        alias: "o",
        type: "string",
        description: "(Required) Overview file path.",
      })
      .option("path", {
        alias: "p",
        type: "string",
        description: "(Required) Execute Path",
      });
  })
  .help().argv;

export const getCommand = (): string | number => {
  const cmd = argv._[0];
  if (!cmd) {
    throw new Error(`Command is undefined. cmd : ${cmd}`);
  }
  return cmd;
};

export const getTfCmd = (): string => {
  const cmd = argv.cmd;
  if (!cmd) {
    throw new Error(`Terraform command is undefined. cmd : ${cmd}`);
  }
  return cmd;
};

export const getEnv = (): string => {
  const env = argv.env;
  if (!env) {
    throw new Error(`Execute environment is undefined. env : ${env}`);
  }
  return env;
};

export const getOverviewFilePath = (): string => {
  const overview = argv.overview;
  if (!overview) {
    throw new Error(`Overview file path is undefined. overview : ${overview}`);
  }
  return overview;
};

export const getPath = (): string => {
  const path = argv.path;
  if (!path) {
    throw new Error(`Target path is undefined. path : ${path}`);
  }
  return path;
};
