{
    inputs.toolchain.url = "github:the-pink-hacker/ce-toolchain-nix";
    outputs = {
        self,
        toolchain,
    }: {
        packages.x86_64-linux.default = toolchain.packages.x86_64-linux.mkDerivation {
            pname = "hi";
            version = "0.0.1";
            src = self;
        };
    };
}
