{ self, super }:
  with super; with super.pythonPackages; buildPythonApplication rec {
    version = "12";
    pname = "pydf";

    src = fetchPypi {
      inherit pname version;
      sha256 = "7f47a7c3abfceb1ac04fc009ded538df1ae449c31203962a1471a4eb3bf21439";
    };
  }
