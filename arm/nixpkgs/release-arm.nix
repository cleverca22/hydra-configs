{ nixpkgs ? { outPath = (import ./all-packages.nix { system = "armv6l-linux"; }).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, supportedSystems ? [ "armv6l-linux" "armv7l-linux" ]
}:

with import ./release-lib.nix { inherit supportedSystems; };

let

jobs = {
  
  #tarball = import ./make-tarball.nix {
  #  inherit nixpkgs;
  #  officialRelease = false;
  #};
} // (mapTestOn (
# (packagePlatforms pkgs) // 
rec {
  acpi = linux;
  atftp = linux;
  autogen = linux;
  autoconf = linux;
  automake = linux;
  avahi = linux;
  bash = all;
  btrfsProgs = linux;
  boost = linux;
  bison = linux;
  cairo = linux;
  cmake = linux;
  check = linux;
  curl = linux;
  dbus_libs = linux;
  dbus_tools = linux;
  dhcpcd = linux;
  docbook_xsl = linux;
  diffutils = linux;
  dtc = linux;
  e2fsprogs = linux;
  file = linux;
  flac = linux;
  fontconfig = linux;
  go = linux;
  gdb = linux;
  gmp = linux;
  gettext = linux;
  git = all;
  glibc = linux;
  glibcLocales = linux;
  guile = linux;
  gnutls = linux;
  findutils = linux;
  iproute = linux;
  jsoncpp = linux;
  kbd = all;
  libnl = linux;
  libsndfile = linux;
  libungif = linux;
  libusb1 = linux;
  libkrb5 = linux;
  libpcap = linux;
  libpng = linux;
  libpng12 = linux;
  linuxPackages_rpi.kernel = linux;
  llvm = all;
  lvm2 = linux;
  lsof = linux;
  mariadb = linux;
  nix = all;
  nix-repl = linux;
  nodejs = linux;
  ntp = linux;
  net_snmp = linux;
  openiscsi = linux;
  openssl = linux;
  openssh = linux;
  parted = linux;
  perl = linux;
  postgresql = linux;
  postgresql93 = linux;
  psmisc = linux;
  ratpoison = linux;
  runit = linux;
  screen = linux;
  spidermonkey_17 = linux;
  spidermonkey = linux;
  stdenv = all;
  strace = linux;
  sysstat = linux;
  socat = linux;
  synergy = linux;
  texinfo = linux;
  tcpdump = linux;
  uthash = linux;
  utillinuxCurses = linux;
  utillinux = linux;
  ubootRaspberryPi = [ "armv6l-linux" ];
  ubootRaspberryPi2 = [ "armv7l-linux" ];
  ubootRaspberryPi3 = [ "armv7l-linux" ];
  uwimap = linux;
  unzip = linux;
  vim = all;
  vnstat = linux;
  w3m = linux;
  xterm = linux;
  xorg = {
    libX11 = linux;
    libXaw = linux;
    libXfont = linux;
    libXft = linux;
    libXfixes = linux;
    libXi = linux;
    libXmu = linux;
    libXrandr = linux;
    libXtst = linux;
    libXt = linux;
    xauth = linux;
  };
  xz = linux;
  #linuxPackages_rpi = linux;
  zlib = linux;
}) );
in
  jobs
