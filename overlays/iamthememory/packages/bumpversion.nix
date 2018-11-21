{ self, super }:
  with super.pythonPackages; buildPythonApplication rec {
    version = "0.5.3";
    pname = "bumpversion";

    src = fetchPypi {
      inherit pname version;
      sha256 = "6744c873dd7aafc24453d8b6a1a0d6d109faf63cd0cd19cb78fd46e74932c77e";
    };
  }
