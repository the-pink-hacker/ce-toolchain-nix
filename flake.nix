{
    description = "A collection of packages for the TI-84 Plus CE graphing calculator.";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        llvm-ez80 = {
            url = "github:CE-Programming/llvm-project";
            flake = false;
        };
        toolchain = {
            flake = false;
            type = "git";
            url = "https://github.com/CE-Programming/toolchain";
            submodules = true;
        };
        convbin = {
            flake = false;
            type = "git";
            url = "https://github.com/mateoconlechuga/convbin";
            submodules = true;
        };
        cemu-ti = {
            flake = false;
            type = "git";
            url = "https://github.com/CE-Programming/CEmu";
            submodules = true;
        };
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = {
        nixpkgs,
        llvm-ez80,
        toolchain,
        convbin,
        self,
        flake-utils,
        ...
    } @ inputs:
        flake-utils.lib.eachSystem [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
        ] (system: let
            pkgsSelf = self.packages.${system};
        in
            with import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            }; {
                templates.ce-toolchain = {
                    path = ./template;
                    description = "A Hello World program for the TI-84 Plus CE";
                };
                formatter = pkgs.alejandra;
                packages = let
                    callPackage = lib.callPackageWith pkgs;
                    callPackageSelf = lib.callPackageWith (pkgs // pkgsSelf);
                in {
                    fasmg-patch = callPackage ./packages/fasmg {};
                    convbin-unstable = callPackage ./packages/convbin {convbin-src = convbin;};
                    llvm-ez80 = callPackage ./packages/llvm-ez80 {llvm-ez80-src = llvm-ez80;};
                    ce-libs = callPackageSelf ./packages/ce-libs {};
                    ce-toolchain = callPackageSelf ./packages/ce-toolchain {
                        ce-toolchain-src = toolchain;
                    };
                    cemu-ti = callPackage ./packages/cemu-ti {
                        cemu-ti-src = inputs.cemu-ti;
                    };
                    mkDerivation = callPackageSelf ./packages/mkDerivation {};
                };
            });
}
