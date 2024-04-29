{ pkgs
, stdenv
, lib
, nix-filter
, ocamlPackages
, static ? false
, doCheck
}:
with ocamlPackages;
buildDunePackage {
  pname = "wol";
  version = "1.0.0";

  src = with nix-filter.lib;
    filter {
      # Root of the project relative to this file
      root = ./..;
      # If no include is passed, it will include all the paths.
      include = [
        # Include the "src" path relative to the root.
        "src"
        "test"
        # Include this specific path. The path must be under the root.
        ../wol.opam
        ../dune-project
      ];
    };

  checkInputs = [
    # Put test dependencies here
    alcotest
  ];

  propagatedBuildInputs = [
    # Put dependencies here if you're creating a library
    eio
    eio_main
    ipaddr
    ipaddr-cstruct
    macaddr
    macaddr-cstruct
  ];

  buildInputs = [
    # Put build-time dependencies here
    cmdliner
  ];

  inherit doCheck;

  meta = {
    description = "Wake on LAN";
    license = pkgs.lib.licenses.bsd3;
  };
}
