import yargs from "yargs";
import { hideBin } from "yargs/helpers";

export const argv = yargs(hideBin(process.argv))
  .option("cmd", {
    alias: "c",
    type: "string",
    description: "terraform command (plan, apply and so on.)",
  })
  .option("env", {
    alias: "e",
    type: "string",
    description: "Execute environment",
  })
  .option("overview", {
    alias: "o",
    type: "string",
    description: "Overview json file path.",
  }).argv;
