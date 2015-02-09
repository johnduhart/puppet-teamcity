class teamcity(
  $version      = '9.0.2',
  $product      = 'teamcity',
  $format       = 'tar.gz',
  $installdir   = '/opt/teamcity',
  $datadir      = '/home/teamcity',
  $user         = 'teamcity',
  $group        = 'teamcity',

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