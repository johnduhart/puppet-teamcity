class teamcity(
  $version      = '9.0.2',
  $product      = 'teamcity',
  $format       = 'tar.gz',
  $installdir   = '/opt/teamcity',
  $datadir      = '/home/teamcity',
  $user         = 'teamcity',
  $group        = 'teamcity',

  # Java Options
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $jvm_permgen  = '256m',

  # Database Settings
  $dbuser       = 'teamcity',
  $dbpassword   = 'password',
  $dburl        = 'jdbc:postgresql://localhost:5432/teamcity',

  $service_ensure = running,
  $service_enable = true,


  $downloadURL = 'http://download.jetbrains.com/teamcity',
) {
  $webappdir    = "${installdir}/jetbrains-${product}-${version}"

  anchor { 'teamcity::start':
  } ->
  class { 'teamcity::install':
    webappdir => $webappdir
  } ->
  class { 'teamcity::config':
  } ~>
  class { 'teamcity::service':
  } ->
  anchor { 'teamcity::end': }
}