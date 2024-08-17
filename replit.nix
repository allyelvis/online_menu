{ pkgs }: {
  deps = [
    pkgs.haskellPackages.concurrent-dns-cache
    pkgs.imagemagick_light
    pkgs.cowsay
  ];
}