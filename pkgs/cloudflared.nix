{
  lib,
  fetchFromGitHub,
  buildGo127Module,
}: let
  version = "2026.10.6";
in
  buildGo127Module {
    pname = "cloudflared";
    inherit version;

    src = fetchFromGitHub {
      owner = "cloudflare";
      repo = "cloudflared";
      tag = version;
      hash = "sha256-WfSJHX1Yj9DQIFhkrt2r9t/ZotZEacsK8aVELWRdW3o=";
    };

    vendorHash = "sha256-ah+kI+bWIZqsi9U+AJtWME9rfjTr6QpiLQy0RXNlDzc=";

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
      "-X github.com/cloudflare/cloudflared/cmd/cloudflared/updater.BuiltForPackageManager=nix"
    ];

    # nixpkgs skips the test suite on Darwin as well (ICMP proxy and other
    # tests require sockets/permissions unavailable in the sandbox).
    doCheck = false;

    meta = with lib; {
      description = "Client for various Cloudflare services, including Tunnel, Access, and DNS over HTTPS";
      homepage = "https://github.com/cloudflare/cloudflared";
      license = licenses.asl20;
      mainProgram = "cloudflared";
      platforms = platforms.unix;
    };
  }
