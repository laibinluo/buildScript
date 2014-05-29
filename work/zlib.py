#!/usr/bin/python

import sys;
import getopt;
import zlib;

def usage():
  print "zlib.py [-d] [-o out] files"
  print "  -d decompress instead of compress"
  print "  -o specific output file instead of stdout"

def main(argv):

  files_in = ["/dev/stdin"]
  file_out = "/dev/stdout"
  decompress = False

  try:                                
    opts, args = getopt.getopt(argv, "do:h", ["help"])
  except getopt.GetoptError:
    usage();
    sys.exit(2);

  for opt, arg in opts:
    if opt in ("-h", "--help"):
      usage();
      sys.exit();
    elif opt == '-d':
      decompress = True;
    elif opt == '-o':
      file_out = arg;

  if args:
    files_in = args

  c = ""
  for file in files_in:
    fi = open(file, "r")
    c += fi.read();
    fi.close()

  if decompress:
    d = zlib.decompress(c)
  else:
    d = zlib.compress(c)
  fo = open(file_out, "w")
  fo.write(d)

if __name__ == "__main__":
    main(sys.argv[1:])
