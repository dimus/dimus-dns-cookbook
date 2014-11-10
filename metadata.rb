name             "dimus-dns"
maintainer       "Dmitry Mozzherin"
maintainer_email "dmozzherin@gmail.com"
license          "MIT"
description      "Installs/Configures maradns"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.3"

%w(ubuntu debian).each { |os| supports os }
