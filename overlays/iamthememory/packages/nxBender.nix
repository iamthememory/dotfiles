{ self, super }:
  with super; with super.pythonPackages; buildPythonApplication rec {
    pname = "nxBender";
    version = "454dedc6c72fc62eedb7be18e62c6b7ee5f82bb3";
    propagatedBuildInputs = [
      ConfigArgParse
      ipaddress
      requests
      ppp
      pyroute2
    ];
    src = fetchFromGitHub {
      owner = "larswolter";
      repo = "nxBender";
      rev = "43c2c545afba84b66a74cbead0396ae798fddc96";
      sha256 = "03shyfjnr1mywliy7imvc0yjbh03q1fljaw02l19ad0syccz8nkz";
    };
  }
