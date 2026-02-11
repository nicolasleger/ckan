# CKAN

* http://github.com/apohllo/CKAN

## DESCRIPTION

'CKAN' is a Ruby client of the Comprehensive Knowledge Archive Network.

## FEATURES/PROBLEMS

* The project is in pre-alpha state.
* CKAN packages REST API wrapper.
* CKAN resources class.
* Query API for CKAN packages.

## SYNOPSIS

'CKAN' is a Ruby client for the Comprehensive Knowledge Archive Network. It
provides an object oriented interface for the repository based on the REST API
of CKAN.

## INSTALL

The gem is available at rubygems.org, so you can install it with:

  $ gem install ckan

## BASIC USAGE

```ruby
  require 'ckan'

  # Optionally, set the base API url
  CKAN::API.api_base = "...your CKAN API URL ..."

  # get all CKAN packages
  packages = CKAN::Package.find

  # query for CKAN packages
  packages = CKAN::Package.find(:tags => ["lod", "government"], :groups => "lodcloud")

  # get the name of the package (this is a lazy call to the REST API)
  packages.first.name

  # get the resources of the package
  packages.first.resources

  # query for CKAN groups
  groups = CKAN::Group.find

  # get the description of a group
  groups.first.description

  # get the list of packages inside a group
  groups.first.packages
```

## LICENSE

See [LICENSE](LICENSE) file.

## FEEDBACK

* mailto:apohllo@o2.pl

