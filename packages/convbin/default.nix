{
    convbin,
    convbin-src,
}:
convbin.overrideAttrs {
    src = convbin-src;
    version = "unstable";
}
