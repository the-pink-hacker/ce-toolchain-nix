# Modified from nixpkgs
{
    stdenv,
    lib,
    cmake,
    pkg-config,
    qt6,
    libarchive,
    libpng,
    cemu-ti-src,
}:
stdenv.mkDerivation (finalAttrs: {
    pname = "CEmu";
    version = "2.0";
    src = cemu-ti-src;
    # TODO: Don't hardcode source directory
    #sourceRoot = "${finalAttrs.src.name}/gui/qt/";
    sourceRoot = "source/gui/qt/";
    patches = [
        # This is resolved upstream, but I can't apply the patch because the
        # sourceRoot isn't set to the base of the Git repo.
        #./resolve-ambiguous-constexpr.patch
        # Disable the deploy_script generation. It's broken with Qt 6.10 and not used by this package.
        ./cmake-no-deploy.patch
    ];
    nativeBuildInputs = [
        cmake
        qt6.wrapQtAppsHook
        pkg-config
    ];
    buildInputs = [
        qt6.qtbase
        libarchive
        libpng
    ];
    meta = {
        description = "Third-party TI-84 Plus CE / TI-83 Premium CE emulator, focused on developer features";
        mainProgram = "CEmu";
        homepage = "https://ce-programming.github.io/CEmu";
        license = lib.licenses.gpl3Plus;
        maintainers = [];
        platforms = lib.platforms.unix;
    };
})
