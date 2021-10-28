# Docker GH action test
A small test/POC for the `docker` daemon in GitHub actions.

## Why
- I wanted to run `docker` in `windows`, `macos` and `linux` in GitHub actions to have a minimal POC.
- Currently it's working for `docker` in version `v20.10.8` for `macos` with the code from this [comment](https://github.com/docker/for-mac/issues/2359#issuecomment-943131345).
- You may wonder why there are still scripts in the `ci-scripts` folder. The reason is: I wanted to keep them if the `Docker.app` changes its install flags, etc. in the future.