import {Overview, OverviewConfig} from "./model";
import fs from "fs";
import {argv} from "./arguments";

export const loadOverviewJson = (): Overview => {
    return JSON.parse(fs.readFileSync(getOverviewFilePath(), "utf-8"));
};

export const loadEnvFile = (config: OverviewConfig): object => {
    return JSON.parse(fs.readFileSync("../" + getEnvFilePath(getEnv(), config), "utf-8"))
}

const getOverviewFilePath = (): string => {
    const path = argv.path;
    if (typeof path === "string") {
        return path;
    }
    throw new Error(`パスが文字列ではありません, path: ${path}`);
};

const getEnv = (): string => {
    const env = argv.env;
    if (typeof env === "string") {
        return env;
    }
    throw new Error(`envが文字列ではありません, env: ${env}`);
}

const getEnvFilePath = (env: string, config: OverviewConfig): string => {
    const variables = config.env_variables.find(variables => variables.name === env);
    if (variables) {
        return variables.file_path
    }
    throw new Error(`env に対応した変数が設定されていません, env: ${env}`)
}