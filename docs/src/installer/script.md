# Script

This is a small script which is serving as installer for this project. It basically:

- Sets up an environment to install the system from
- Asks for basic information such as the disk to be used or the username
- Sets up the partition layout via [disko](https://github.com/nix-community/disko) and mounting the partitons to `/mnt`
- Provides a basic, quite generic dr460nixed template and customizes it based on previous choices
- Executes the installation

```nix
{{#include ../../../packages/installer.sh}}
```
