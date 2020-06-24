{boto3, buildPythonPackage, crc32c, fetchFromGitHub, lib, matplotlib, moto, numpy, pillow, pytorch, protobuf, six, pytest, tensorflow-tensorboard, torchvision }:

buildPythonPackage rec {
  pname = "tensorboardx";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    rev = "v${version}";
    sha256 = "0qqalq0fhbx0wnd8wdwhyhkkv2brvj9qbk3373vk3wjxbribf5c7";
  };

  checkInputs = [ boto3 crc32c matplotlib moto pillow pytorch pytest tensorflow-tensorboard torchvision ];

  propagatedBuildInputs = [ numpy protobuf six ];

  postPatch=''
    substituteInPlace tests/test_summary.py --replace test_mesh _skip_test_mesh
    substituteInPlace tests/test_summary.py --replace test_audio _skip_test_audio
    substituteInPlace tests/test_summary.py --replace test_histogram_auto _skip_histogram_auto
    substituteInPlace tests/test_summary.py --replace test_histogram_doane  _skip_test_histogram_doane
    substituteInPlace tests/test_summary.py --replace test_histogram_fd _skip_test_histogram_fd

    substituteInPlace tests/test_visdom.py --replace test_TorchVis _skip_test_TorchVis
    substituteInPlace tests/test_onnx_graph.py --replace test_onnx_graph _skip_test_onnx_graph
    '';

  meta = {
    description = "Library for writing tensorboard-compatible logs";
    homepage = https://github.com/lanpa/tensorboard-pytorch;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lebastr akamaus ];
    platforms = lib.platforms.all;
  };
}
