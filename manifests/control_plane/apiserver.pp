# == Class: hyperkube::control_plane::apiserver
#
# Sets up a Kubernetes manifest for running an apiserver
#
# === Parameters
#
#
# === Examples
#
# @example
#    class { 'hyperkube::control_plane::apiserver':
#      $allow_privileged = true,
#      $apiserver_count = 2,
#      $etcd_servers = [ 'https://1.2.3.4:2379', 'http://127.0.0.1:4001' ],
#      $service_cluster_ip_range = '10.0.1.0/24',
#    }
#
# === Authors
#
# Alexander Olofsson <alexander.olofsson@liu.se>
#
# === Copyright
#
# Copyright 2017 Linköping University
#
class hyperkube::control_plane::apiserver(
  # Required parameters
  Array[Hyperkube::URI] $etcd_servers,
  Hyperkube::CIDR $service_cluster_ip_range = '10.0.0.0/24',

  # Meta parameters
  String $docker_registry = $hyperkube::docker_registry,
  String $docker_image = $hyperkube::docker_image,
  String $docker_image_tag = pick($hyperkube::docker_image_tag, "v${hyperkube::version}"),

  # APIServer parameters
  Optional[Array[Variant[Enum['AlwaysAdmit', 'AlwaysDeny', 'AlwaysPullImages', 'DefaultStorageClass', 'DefaultTolerationSeconds', 'DenyEscalatingExec', 'DenyExecOnPrivileged', 'EventRateLimit', 'GenericAdmissionWebhook', 'ImagePolicyWebhook', 'InitialResources', 'Initializers', 'LimitPodHardAntiAffinityTopology', 'LimitRanger', 'NamespaceAutoProvision', 'NamespaceExists', 'NamespaceLifecycle', 'NodeRestriction', 'OwnerReferencesPermissionEnforcement', 'PersistentVolumeClaimResize', 'PersistentVolumeLabel', 'PodNodeSelector', 'PodPreset', 'PodSecurityPolicy', 'PodTolerationRestriction', 'Priority', 'ResourceQuota', 'SecurityContextDeny', 'ServiceAccount'],String]]] $admission_control = undef, # lint:ignore:140chars
  Optional[String] $admission_control_config_file = undef,
  Optional[Stdlib::Compat::Ip_address] $advertise_address = undef,
  Optional[Boolean] $allow_privileged = undef,
  Optional[Boolean] $allow_verification_with_non_compliant_keys = undef,
  Optional[Boolean] $alsologtostderr = undef,
  Optional[Boolean] $anonymous_auth = undef,
  Optional[Integer[1]] $apiserver_count = undef,
  Optional[Integer[0]] $application_metrics_count_limit = undef,
  Optional[Enum['json','legacy']] $audit_log_format = undef,
  Optional[Integer[0]] $audit_log_maxage = undef,
  Optional[Integer[0]] $audit_log_maxbackup = undef,
  Optional[Integer[0]] $audit_log_maxsize = undef,
  Optional[Variant[Enum['-'],Stdlib::Unixpath]] $audit_log_path = undef,
  Optional[Stdlib::Unixpath] $audit_policy_file = undef,
  Optional[Stdlib::Unixpath] $audit_webhook_config_file = undef,
  Optional[Enum['batch','blocking']] $audit_webhook_mode = undef,
  Optional[Hyperkube::Duration] $authentication_token_webhook_cache_ttl = undef,
  Optional[Stdlib::Unixpath] $authentication_token_webhook_config_file = undef,
  Optional[Array[Variant[Enum['AlwaysAllow','AlwaysDeny','ABAC','Webhook','RBAC','Node'],String]]] $authorization_mode = undef,
  Optional[Stdlib::Unixpath] $authorization_policy_file = undef,
  Optional[Hyperkube::Duration] $authorization_webhook_cache_authorized_ttl = undef,
  Optional[Hyperkube::Duration] $authorization_webhook_cache_unauthorized_ttl = undef,
  Optional[Stdlib::Unixpath] $authorization_webhook_config_file = undef,
  Optional[Stdlib::Unixpath] $azure_container_registry_config = undef,
  Optional[Stdlib::Unixpath] $basic_auth_file = undef,
  Optional[Stdlib::Compat::Ip_address] $bind_address = undef,
  Optional[Array[Stdlib::Unixpath]] $boot_id_file = undef,
  Optional[Stdlib::Unixpath] $cert_dir = undef,
  Optional[Stdlib::Unixpath] $client_ca_file = undef,
  Optional[Stdlib::Unixpath] $cloud_config = undef,
  Optional[String] $cloud_provider = undef,
  Optional[Array[Hyperkube::CIDR]] $cloud_provider_gce_lb_src_cidrs = undef,
  Optional[Stdlib::Unixpath] $container_hints = undef,
  Optional[Boolean] $contention_profiling = undef,
  Optional[Array[String]] $cors_allowed_origins = undef,
  Optional[Integer[0]] $default_not_ready_toleration_seconds = undef,
  Optional[Integer[0]] $default_unreachable_toleration_seconds = undef,
  Optional[Integer[0]] $default_watch_cache_size = undef,
  Optional[Integer[1]] $delete_collection_workers = undef,
  Optional[Integer[0]] $deserialization_cache_size = undef,
  Optional[Hyperkube::URI] $docker = undef,
  Optional[Array[String]] $docker_env_metadata_whitelist = undef,
  Optional[Boolean] $docker_only = undef,
  Optional[Stdlib::Unixpath] $docker_root = undef,
  Optional[Boolean] $docker_tls = undef,
  Optional[Stdlib::Unixpath] $docker_tls_ca = undef,
  Optional[Stdlib::Unixpath] $docker_tls_cert = undef,
  Optional[Stdlib::Unixpath] $docker_tls_key = undef,
  Optional[Boolean] $enable_aggregator_routing = undef,
  Optional[Boolean] $enable_bootstrap_token_auth = undef,
  Optional[Boolean] $enable_garbage_collector = undef,
  Optional[Boolean] $enable_load_reader = undef,
  Optional[Boolean] $enable_logs_handler = undef,
  Optional[Boolean] $enable_swagger_ui = undef,
  Optional[Stdlib::Unixpath] $etcd_cafile = undef,
  Optional[Stdlib::Unixpath] $etcd_certfile = undef,
  Optional[Stdlib::Unixpath] $etcd_keyfile = undef,
  Optional[Stdlib::Unixpath] $etcd_prefix = undef,
  Optional[Boolean] $etcd_quorum_read = undef,
  Optional[Array[String]] $etcd_servers_overrides = undef,
  Optional[Hash[String,Hyperkube::Duration]] $event_storage_age_limit = undef,
  Optional[Hash[String,Hyperkube::Duration]] $event_storage_event_limit = undef,
  Optional[Hyperkube::Duration] $event_ttl = undef,
  Optional[Stdlib::Unixpath] $experimental_encryption_provider_config = undef,
  Optional[Stdlib::Unixpath] $experimental_keystone_ca_file = undef,
  Optional[Hyperkube::URI] $experimental_keystone_url = undef,
  Optional[String] $external_hostname = undef,
  Optional[Hash[String,Boolean]] $feature_gates = undef,
  Optional[Hyperkube::Duration] $global_housekeeping_interval = undef,
  Optional[String] $google_json_key = undef,
  Optional[Hyperkube::Duration] $housekeeping_interval = undef,
  Optional[Stdlib::Compat::Ip_address] $insecure_bind_address = undef,
  Optional[Integer[1,65535]] $insecure_port = 8080,
  Optional[Enum['influxdb','gcm']] $ir_data_source = undef,
  Optional[String] $ir_dbname = undef,
  Optional[Hyperkube::URI] $ir_hawkular = undef,
  Optional[String] $ir_influxdb_host = undef,
  Optional[Boolean] $ir_namespace_only = undef,
  Optional[String] $ir_password = undef,
  Optional[Integer[0]] $ir_percentile = undef,
  Optional[String] $ir_user = undef,
  Optional[Stdlib::Unixpath] $kubelet_certificate_authority = undef,
  Optional[Stdlib::Unixpath] $kubelet_client_certificate = undef,
  Optional[Stdlib::Unixpath] $kubelet_client_key = undef,
  Optional[Boolean] $kubelet_https = undef,
  Optional[Array[Enum['Hostname','InternalDNS','InternalIP','ExternalDNS','ExternalIP']]] $kubelet_preferred_address_types = undef,
  Optional[Integer[0]] $kubelet_read_only_port = undef,
  Optional[Hyperkube::Duration] $kubelet_timeout = undef,
  Optional[Integer[0]] $kubernetes_service_node_port = undef,
  Optional[String] $log_backtrace_at = undef,
  Optional[Boolean] $log_cadvisor_usage = undef,
  Optional[Stdlib::Unixpath] $log_dir = undef,
  Optional[Hyperkube::Duration] $log_flush_frequency = undef,
  Optional[Integer[0,5]] $loglevel = undef,
  Optional[Boolean] $logtostderr = undef,
  Optional[Array[Stdlib::Unixpath]] $machine_id_file = undef,
  Optional[String] $master_service_namespace = undef,
  Optional[Integer[0]] $max_connection_bytes_per_sec = undef,
  Optional[Integer[0]] $max_mutating_requests_inflight = undef,
  Optional[Integer[0]] $max_requests_inflight = undef,
  Optional[Integer[0]] $min_request_timeout = undef,
  Optional[Stdlib::Unixpath] $oidc_ca_file = undef,
  Optional[String] $oidc_client_id = undef,
  Optional[Variant[String,Array[String]]] $oidc_groups_claim = undef,
  Optional[String] $oidc_groups_prefix = undef,
  Optional[Stdlib::HTTPSUrl] $oidc_issuer_url = undef,
  Optional[String] $oidc_username_claim = undef,
  Optional[String] $oidc_username_prefix = undef,
  Optional[Boolean] $profiling = undef,
  Optional[Stdlib::Unixpath] $proxy_client_cert_file = undef,
  Optional[Stdlib::Unixpath] $proxy_client_key_file = undef,
  Optional[Boolean] $repair_malformed_updates = undef,
  Optional[Hyperkube::Duration] $request_timeout = undef,
  Optional[Array[String]] $requestheader_allowed_names = undef,
  Optional[Stdlib::Unixpath] $requestheader_client_ca_file = undef,
  Optional[Array[String]] $requestheader_extra_headers_prefix = undef,
  Optional[Array[String]] $requestheader_group_headers = undef,
  Optional[Array[String]] $requestheader_username_headers = undef,
  Optional[Hash[String,String]] $runtime_config = undef,
  Optional[Integer[1,65535]] $secure_port = 6443,
  Optional[Variant[[Stdlib::Unixpath],Array[Stdlib::Unixpath]]] $service_account_key_file = undef,
  Optional[Boolean] $service_account_lookup = undef,
  Optional[Hyperkube::PortRange] $service_node_port_range = undef,
  Optional[Stdlib::Unixpath] $ssh_keyfile = undef,
  Optional[String] $ssh_user = undef,
  Optional[Integer[0,5]] $stderrthreshold = undef,
  Optional[Enum['etcd3','etcd2']] $storage_backend = undef,
  Optional[Hyperkube::Duration] $storage_driver_buffer_duration = undef,
  Optional[String] $storage_driver_db = undef,
  Optional[String] $storage_driver_host = undef,
  Optional[String] $storage_driver_password = undef,
  Optional[Boolean] $storage_driver_secure = undef,
  Optional[String] $storage_driver_table = undef,
  Optional[String] $storage_driver_user = undef,
  Optional[String] $storage_media_type = undef,
  Optional[String] $storage_versions = undef,
  Optional[Integer[1]] $target_ram_mb = undef,
  Optional[Stdlib::Unixpath] $tls_ca_file = undef,
  Optional[Stdlib::Unixpath] $tls_cert_file = undef,
  Optional[Stdlib::Unixpath] $tls_private_key_file = undef,
  Optional[Array[String]] $tls_sni_cert_key = undef,
  Optional[Stdlib::Unixpath] $token_auth_file = undef,
  Optional[Integer[0,10]] $v = undef,
  Optional[Hash[String,Integer[0,10]]] $vmodule = undef,
  Optional[Boolean] $watch_cache = undef,
  Optional[Array[String]] $watch_cache_sizes = undef,

  Optional[Variant[String,Array[String]]] $extra_parameters = undef,

  Enum['present','absent'] $ensure = present,
) {
  if $extra_parameters != undef {
    if $extra_parameters =~ String {
      $_extra_parameters = [$extra_parameters]
    } else {
      $_extra_parameters = $extra_parameters
    }
  } else {
    $_extra_parameters = []
  }

  $parameters = {
    'admission-control'                            => $admission_control,
    'admission-control-config-file'                => $admission_control_config_file,
    'advertise-address'                            => $advertise_address,
    'allow-privileged'                             => $allow_privileged,
    'allow-verification-with-non-compliant-keys'   => $allow_verification_with_non_compliant_keys,
    'alsologtostderr'                              => $alsologtostderr,
    'anonymous-auth'                               => $anonymous_auth,
    'apiserver-count'                              => $apiserver_count,
    'application-metrics-count-limit'              => $application_metrics_count_limit,
    'audit-log-format'                             => $audit_log_format,
    'audit-log-maxage'                             => $audit_log_maxage,
    'audit-log-maxbackup'                          => $audit_log_maxbackup,
    'audit-log-maxsize'                            => $audit_log_maxsize,
    'audit-log-path'                               => $audit_log_path,
    'audit-policy-file'                            => $audit_policy_file,
    'audit-webhook-config-file'                    => $audit_webhook_config_file,
    'audit-webhook-mode'                           => $audit_webhook_mode,
    'authentication-token-webhook-cache-ttl'       => $authentication_token_webhook_cache_ttl,
    'authentication-token-webhook-config-file'     => $authentication_token_webhook_config_file,
    'authorization-mode'                           => $authorization_mode,
    'authorization-policy-file'                    => $authorization_policy_file,
    'authorization-webhook-cache-authorized-ttl'   => $authorization_webhook_cache_authorized_ttl,
    'authorization-webhook-cache-unauthorized-ttl' => $authorization_webhook_cache_unauthorized_ttl,
    'authorization-webhook-config-file'            => $authorization_webhook_config_file,
    'azure-container-registry-config'              => $azure_container_registry_config,
    'basic-auth-file'                              => $basic_auth_file,
    'bind-address'                                 => $bind_address,
    'boot-id-file'                                 => $boot_id_file,
    'cert-dir'                                     => $cert_dir,
    'client-ca-file'                               => $client_ca_file,
    'cloud-config'                                 => $cloud_config,
    'cloud-provider'                               => $cloud_provider,
    'cloud-provider-gce-lb-src-cidrs'              => $cloud_provider_gce_lb_src_cidrs,
    'container-hints'                              => $container_hints,
    'contention-profiling'                         => $contention_profiling,
    'cors-allowed-origins'                         => $cors_allowed_origins,
    'default-not-ready-toleration-seconds'         => $default_not_ready_toleration_seconds,
    'default-unreachable-toleration-seconds'       => $default_unreachable_toleration_seconds,
    'default-watch-cache-size'                     => $default_watch_cache_size,
    'delete-collection-workers'                    => $delete_collection_workers,
    'deserialization-cache-size'                   => $deserialization_cache_size,
    'docker'                                       => $docker,
    'docker-env-metadata-whitelist'                => $docker_env_metadata_whitelist,
    'docker-only'                                  => $docker_only,
    'docker-root'                                  => $docker_root,
    'docker-tls'                                   => $docker_tls,
    'docker-tls-ca'                                => $docker_tls_ca,
    'docker-tls-cert'                              => $docker_tls_cert,
    'docker-tls-key'                               => $docker_tls_key,
    'enable-aggregator-routing'                    => $enable_aggregator_routing,
    'enable-bootstrap-token-auth'                  => $enable_bootstrap_token_auth,
    'enable-garbage-collector'                     => $enable_garbage_collector,
    'enable-load-reader'                           => $enable_load_reader,
    'enable-logs-handler'                          => $enable_logs_handler,
    'enable-swagger-ui'                            => $enable_swagger_ui,
    'etcd-cafile'                                  => $etcd_cafile,
    'etcd-certfile'                                => $etcd_certfile,
    'etcd-keyfile'                                 => $etcd_keyfile,
    'etcd-prefix'                                  => $etcd_prefix,
    'etcd-quorum-read'                             => $etcd_quorum_read,
    'etcd-servers'                                 => $etcd_servers,
    'etcd-servers-overrides'                       => $etcd_servers_overrides,
    'event-storage-age-limit'                      => $event_storage_age_limit,
    'event-storage-event-limit'                    => $event_storage_event_limit,
    'event-ttl'                                    => $event_ttl,
    'experimental-encryption-provider-config'      => $experimental_encryption_provider_config,
    'experimental-keystone-ca-file'                => $experimental_keystone_ca_file,
    'experimental-keystone-url'                    => $experimental_keystone_url,
    'external-hostname'                            => $external_hostname,
    'feature-gates'                                => $feature_gates,
    'global-housekeeping-interval'                 => $global_housekeeping_interval,
    'google-json-key'                              => $google_json_key,
    'housekeeping-interval'                        => $housekeeping_interval,
    'insecure-bind-address'                        => $insecure_bind_address,
    'insecure-port'                                => $insecure_port,
    'ir-data-source'                               => $ir_data_source,
    'ir-dbname'                                    => $ir_dbname,
    'ir-hawkular'                                  => $ir_hawkular,
    'ir-influxdb-host'                             => $ir_influxdb_host,
    'ir-namespace-only'                            => $ir_namespace_only,
    'ir-password'                                  => $ir_password,
    'ir-percentile'                                => $ir_percentile,
    'ir-user'                                      => $ir_user,
    'kubelet-certificate-authority'                => $kubelet_certificate_authority,
    'kubelet-client-certificate'                   => $kubelet_client_certificate,
    'kubelet-client-key'                           => $kubelet_client_key,
    'kubelet-https'                                => $kubelet_https,
    'kubelet-preferred-address-types'              => $kubelet_preferred_address_types,
    'kubelet-read-only-port'                       => $kubelet_read_only_port,
    'kubelet-timeout'                              => $kubelet_timeout,
    'kubernetes-service-node-port'                 => $kubernetes_service_node_port,
    'log-backtrace-at'                             => $log_backtrace_at,
    'log-cadvisor-usage'                           => $log_cadvisor_usage,
    'log-dir'                                      => $log_dir,
    'log-flush-frequency'                          => $log_flush_frequency,
    'loglevel'                                     => $loglevel,
    'logtostderr'                                  => $logtostderr,
    'machine-id-file'                              => $machine_id_file,
    'master-service-namespace'                     => $master_service_namespace,
    'max-connection-bytes-per-sec'                 => $max_connection_bytes_per_sec,
    'max-mutating-requests-inflight'               => $max_mutating_requests_inflight,
    'max-requests-inflight'                        => $max_requests_inflight,
    'min-request-timeout'                          => $min_request_timeout,
    'oidc-ca-file'                                 => $oidc_ca_file,
    'oidc-client-id'                               => $oidc_client_id,
    'oidc-groups-claim'                            => $oidc_groups_claim,
    'oidc-groups-prefix'                           => $oidc_groups_prefix,
    'oidc-issuer-url'                              => $oidc_issuer_url,
    'oidc-username-claim'                          => $oidc_username_claim,
    'oidc-username-prefix'                         => $oidc_username_prefix,
    'profiling'                                    => $profiling,
    'proxy-client-cert-file'                       => $proxy_client_cert_file,
    'proxy-client-key-file'                        => $proxy_client_key_file,
    'repair-malformed-updates'                     => $repair_malformed_updates,
    'request-timeout'                              => $request_timeout,
    'requestheader-allowed-names'                  => $requestheader_allowed_names,
    'requestheader-client-ca-file'                 => $requestheader_client_ca_file,
    'requestheader-extra-headers-prefix'           => $requestheader_extra_headers_prefix,
    'requestheader-group-headers'                  => $requestheader_group_headers,
    'requestheader-username-headers'               => $requestheader_username_headers,
    'runtime-config'                               => $runtime_config,
    'secure-port'                                  => $secure_port,
    'service-account-key-file'                     => $service_account_key_file,
    'service-account-lookup'                       => $service_account_lookup,
    'service-cluster-ip-range'                     => $service_cluster_ip_range,
    'service-node-port-range'                      => $service_node_port_range,
    'ssh-keyfile'                                  => $ssh_keyfile,
    'ssh-user'                                     => $ssh_user,
    'stderrthreshold'                              => $stderrthreshold,
    'storage-backend'                              => $storage_backend,
    'storage-driver-buffer-duration'               => $storage_driver_buffer_duration,
    'storage-driver-db'                            => $storage_driver_db,
    'storage-driver-host'                          => $storage_driver_host,
    'storage-driver-password'                      => $storage_driver_password,
    'storage-driver-secure'                        => $storage_driver_secure,
    'storage-driver-table'                         => $storage_driver_table,
    'storage-driver-user'                          => $storage_driver_user,
    'storage-media-type'                           => $storage_media_type,
    'storage-versions'                             => $storage_versions,
    'target-ram-mb'                                => $target_ram_mb,
    'tls-ca-file'                                  => $tls_ca_file,
    'tls-cert-file'                                => $tls_cert_file,
    'tls-private-key-file'                         => $tls_private_key_file,
    'tls-sni-cert-key'                             => $tls_sni_cert_key,
    'token-auth-file'                              => $token_auth_file,
    'vmodule'                                      => $vmodule,
    'watch-cache'                                  => $watch_cache,
    'watch-cache-sizes'                            => $watch_cache_sizes,
  }

  $parameter_result = $parameters.filter |$k,$v| { $v != undef }.map |$k,$v| {
    if $v =~ Array {
      "--${k}=${join($v, ',')}"
    } elsif $v =~ Hash {
      $reduced = $v.map |$mk, $mv| { "${mk}=${mv}" }
      "--${k}=${join($reduced, ',')}"
    } else {
      "--${k}=${v}"
    }
  } + $_extra_parameters

  if $ensure == 'absent' {
    file {
      default:
        ensure => absent;

      '/etc/kubernetes/manifests/kube-apiserver.yaml': ;
      '/etc/kubernetes/apiserver': ;
      '/opt/hyperkube/bin/kube-apiserver': ;
    }
    service { 'kube-apiserver':
      ensure => stopped,
      enable => false,
    }
  } else {
    if $hyperkube::packaging == 'docker' {
      file { '/etc/kubernetes/manifests/kube-apiserver.yaml':
        ensure  => file,
        content => epp('hyperkube/control_plane/kube-apiserver.yaml.epp', {
            arguments     => $parameter_result,
            full_image    => "${docker_registry}/${docker_image}:${docker_image_tag}",
            insecure_port => pick($insecure_port, 8080),
            secure_port   => pick($secure_port, 6443),
        }),
      }
    } else {
      file { '/etc/kubernetes/apiserver':
        ensure  => file,
        content => epp('hyperkube/sysconfig.epp', {
            comment               => 'Kubernetes APIServer Configuration',
            environment_variables => {
              'KUBE_APISERVER_ARGS' => join($parameter_result, ' '),
            }
        }),
      }

      file { '/opt/hyperkube/bin/kube-apiserver':
        ensure => link,
        target => "/opt/hyperkube/bin/hyperkube-${hyperkube::version}",
      }
      systemd::unit_file { 'kube-apiserver.service':
        content => epp('hyperkube/control_plane/kube-apiserver.service.epp'),
      }
      ~> service { 'kube-apiserver':
        ensure    => running,
        enable    => true,
        subscribe => [
          File['/opt/hyperkube/bin/kube-apiserver'],
          File['/etc/kubernetes/apiserver'],
        ],
      }

      Exec['systemctl-daemon-reload'] -> Service['kube-apiserver']
    }
  }
}
