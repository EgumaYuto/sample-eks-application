import { extractModulePaths } from "./index";

describe("main の単体テスト", () => {
  it("extractModulePaths", () => {
    // given
    const testDirectories = [
      {
        path: "platform",
        type: undefined,
        directories: [
          {
            path: "network",
            type: undefined,
            directories: [
              {
                path: "main",
                type: undefined,
                directories: [
                  {
                    path: "vpc",
                    type: "module" as "module",
                    directories: undefined,
                  },
                  {
                    path: "subnet",
                    type: undefined,
                    directories: [
                      {
                        path: "public",
                        type: "module" as "module",
                        directories: undefined,
                      },
                      {
                        path: "private",
                        type: "module" as "module",
                        directories: undefined,
                      },
                    ],
                  },
                ],
              },
            ],
          },
        ],
      },
    ];

    // when
    const actual = extractModulePaths(testDirectories, []);

    // then
    expect(actual).toEqual([
      "platform/network/main/vpc",
      "platform/network/main/subnet/public",
      "platform/network/main/subnet/private",
    ]);
  });

  // TODO 実験用なので消す
  // it("fs", () => {
  //   expect(existsPath("../platform/network/main/vpc")).toEqual(true);
  //   console.log(JSON.stringify(loadDirectoriesJson()));
  // });
});
