{
  config ? { },
  system ? builtins.currentSystem,
}:
let
  flake =
    (import (
      let
        lock = builtins.fromJSON (builtins.readFile ./flake.lock);
        nodeName = lock.nodes.root.inputs.flake-compat;
      in
      fetchTarball {
        url =
          lock.nodes.${nodeName}.locked.url
            or "https://github.com/edolstra/flake-compat/archive/${lock.nodes.${nodeName}.locked.rev}.tar.gz";
        sha256 = lock.nodes.${nodeName}.locked.narHash;
      }
    ) { src = ./.; }).outputs;
in
import flake.inputs.nixpkgs {
  inherit config system;
  overlays = [
    flake.overlays.default
    flake.inputs.rust-overlay.overlays.default
  ];
}
