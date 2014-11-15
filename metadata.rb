name             "dimus-dns"
maintainer       "Dmitry Mozzherin"
maintainer_email "dmozzherin@gmail.com"
license          "MIT"
description      "Installs/Configures dns server"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.5"

%w(ubuntu debian centos).each { |os| supports os }

depends "apt", "~> 2.6"

