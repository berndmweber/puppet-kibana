# == Class: kibana::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'kibana::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class kibana::config {

  #### Configuration

  if $kibana::config_file != false {

    file { 'kibana_config':
      ensure  => 'present',
      path    => "${kibana::params::install_path}/KibanaConfig.rb",
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template ( "kibana/${kibana::config_file}.erb" ),
      notify  => [ Exec [ 'configure-kibana' ], Service['kibana'] ],
    }

    exec { 'configure-kibana' :
      cwd         => $kibana::params::install_path,
      path        => ['/usr/bin', '/bin', '/usr/local/bin'],
      command     => 'bundle install',
      refreshonly => true,
      require     => Class [ 'ruby::configure' ],
    }

  }
}
