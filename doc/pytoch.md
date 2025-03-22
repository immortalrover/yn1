# How to use pytorch on NixOS ?

The answer is [here](https://discourse.nixos.org/t/pytorch-with-cuda-support/51189/5).
Oh, I really like it!

## Step by step

1. use `direnv` create a `flake.nix`

zsh run
```
flakify
```
and my .zshrc
```
flakify() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  ${EDITOR:-nvim} flake.nix
}
```

2. paste these code into `flake.nix`

**Note: Do not install PyTorch directly in the `flake.nix`.**
```flake.nix
{
  description = "PyTorch with cuda";

  inputs = {
    # It is unrelated to the URL of nixpkgs, any version can be used.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:

  let
    pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
  in
  {
    devShells."x86_64-linux".default = pkgs.mkShell {
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
        "/run/opengl-driver"
      ];
      venvDir = ".venv";
      packages = with pkgs; [
        python312
        # Do not install PyTorch with cuda directly here!!!
        python312Packages.venvShellHook
        python312Packages.pip
        python312Packages.numpy
        python312Packages.pyqt6
      ];
    };
  };
}
```
3. install PyTorch

Wait for direnv to automatically load `flake.nix` (or manually run `nix develop`)
and then use pip to install PyTorch.
It will help you download it into the `.venv` environment.
```pip
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126
```
> Search for PyTorch, then scroll down to find the best installation method for you.
