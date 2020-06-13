output cluster_settings {
  value       = module.cluster_settings.settings
  description = "The computed cluster settings"
  depends_on  = [module.cluster_settings]
}
