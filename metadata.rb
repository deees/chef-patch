name             'patch'
maintainer       'Jens Segers'
maintainer_email ''
license          'MIT'
description      'Some handy Chef resources for when you want to append, replace or delete and lines in files.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.1'
source_url       'https://github.com/jenssegers/chef-patch'
issues_url       'https://github.com/jenssegers/chef-patch/issues'

%w(amazon centos debian fedora redhat scientific ubuntu).each do |os|
  supports os
end

chef_version '>= 12.5'
