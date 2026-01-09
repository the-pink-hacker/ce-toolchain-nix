{
    stdenv,
    ce-toolchain,
    convbin-unstable,
    convimg,
    convfont,
    llvm-ez80,
    fasmg,
}: attrs:
stdenv.mkDerivation (attrs
    // {
        buildPhase =
            if attrs? buildPhase
            then attrs.buildPhase
            else ''
                runHook preBuild
                make gfx $makeFlags || true
                make $makeFlags
                runHook postBuild
            '';
        enableParallelBuilding = true;
        installPhase =
            if attrs ? installPhase
            then attrs.installPhase
            else ''
                runHook preInstall
                mkdir -p $out/
                cp *.8x* */*.8x* */*/*.8x* */*/*/*.8x* $out/
                cp README* readme* license* LICENSE* LISEZMOI* lisezmoi* $out
                runHook postInstall
            '';
        nativeBuildInputs = let
            toolchain = [
                ce-toolchain
                convbin-unstable
                convimg
                convfont
                llvm-ez80
                fasmg
            ];
        in
            if attrs ? nativeBuildInputs
            then attrs.nativeBuildInputs ++ toolchain
            else toolchain;
    })
