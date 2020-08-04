# ---------------------------------------------------------------------------------------------------------------------
# NOTIFICATION CHANNELS
# ---------------------------------------------------------------------------------------------------------------------

module "gke_notification_channel" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster?ref=v0.2.0"
  source = "./modules/gke-notification-channel"

  project  = var.project

  notification_channel_type = "email"
  display_name = "Cluster EMT"
  cluster_emt_email = "cluster_emt@gmail.com"
}

# ---------------------------------------------------------------------------------------------------------------------
# ALERT POLICIES
# ---------------------------------------------------------------------------------------------------------------------

resource "google_monitoring_alert_policy" "cluster_4hrs_uptime_alert" {
  display_name = "Container Uptime Limit (4hrs,14400ms) (for ${var.project}/${module.gke_cluster.name} via kube-system/kube-proxy)"
  combiner = "OR"
  conditions {
    display_name = "Container Uptime Limit (4hrs)"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/uptime\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.project}\" resource.label.\"cluster_name\"=\"${module.gke_cluster.name}\" resource.label.\"namespace_name\"=\"kube-system\" resource.label.\"container_name\"=\"kube-proxy\""
      duration = "300s"
      comparison = "COMPARISON_GT"
      threshold_value = 14400 # (s) 4 hours
      trigger {
          count = 1
      }
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  documentation {
    content = "The Cluster Lifespan rule has generated this alert."
  }
  notification_channels = [
      "${module.gke_notification_channel.emt_email_id}",
  ]
}

resource "google_monitoring_alert_policy" "container_cpu_limit_util" {
  display_name = "Container CPU Limit Utilization (80%) (for ${var.project}/${module.gke_cluster.name} by namespace)"
  combiner = "OR"
  conditions {
    display_name = "Container CPU Limit Utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.project}\" resource.label.\"cluster_name\"=\"${module.gke_cluster.name}\""
      duration = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.80
      trigger {
          count = 1
      }
      aggregations {
        cross_series_reducer = "REDUCE_SUM"
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["resource.label.namespace_name"]
      }
    }
  }
  documentation {
    content = "The Container CPU Limit Utitlization rule has generated this alert."
  }
  notification_channels = [
      "${module.gke_notification_channel.emt_email_id}",
  ]
}


resource "google_monitoring_alert_policy" "container_memory_limit_util" {
  display_name = "Container Memory Limit Utilization (80%) (for ${var.project}/${module.gke_cluster.name} by namespace)"
  combiner = "OR"
  conditions { 
    display_name = "Container Memory Limit Utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.project}\" resource.label.\"cluster_name\"=\"${module.gke_cluster.name}\""
      duration= "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.80
      trigger {
          count = 1
      }
      aggregations {
        alignment_period = "60s"
        cross_series_reducer = "REDUCE_MEAN"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["resource.label.namespace_name"]
      }
    }
  }
  documentation {
    content = "The Container Memory Limit Utitlization rule has generated this alert."
  }
  notification_channels = [
      "${module.gke_notification_channel.emt_email_id}",
  ]
}


resource "google_monitoring_alert_policy" "node_cpu_allocatable_util" {
  display_name = "Node CPU Allocatable Utilization (80%) (for ${var.project}/${module.gke_cluster.name})"
  combiner = "OR"
  conditions {
    display_name = "Node CPU Allocatable Utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/cpu/allocatable_utilization\" resource.type=\"k8s_node\" resource.label.\"project_id\"=\"${var.project}\" resource.label.\"cluster_name\"=\"${module.gke_cluster.name}\""
      duration = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.8
      trigger {
          count = 1
      }
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }  
  documentation {
    content = "The Node CPU Allocatable Utitlization rule has generated this alert."
  }
  notification_channels = [
    "${module.gke_notification_channel.emt_email_id}",
  ]
}


resource "google_monitoring_alert_policy" "node_memory_allocatable_util" {
  display_name = "Node Memory Allocatable Utilization (80%) (for ${var.project}/${module.gke_cluster.name} by node)"
  combiner = "OR"
  conditions {
    display_name = "Node Memory Limit Utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/memory/allocatable_utilization\" resource.type=\"k8s_node\" resource.label.\"project_id\"=\"${var.project}\" resource.label.\"cluster_name\"=\"${module.gke_cluster.name}\""
      duration= "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.8
      trigger {
          count = 1
      }
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["resource.label.component","resource.label.node_name"]
      }
    }
  }
  documentation {
    content = "The Node Memory Allocatable Utitlization rule has generated this alert."
  }
  notification_channels = [
      "${module.gke_notification_channel.emt_email_id}",
  ]
}

resource "google_monitoring_alert_policy" "node_allocatable_ephemeral_storage" {
  display_name = "Node Allocatable Ephemeral Storage (below 25%,2GiB) (for ${var.project}/${module.gke_cluster.name})"
  combiner = "OR"
  conditions {
    display_name = "Node Allocatable Ephemeral Storage"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/ephemeral_storage/allocatable_bytes\" resource.type=\"k8s_node\" resource.label.\"project_id\"=\"${var.project}\" resource.label.\"cluster_name\"=\"${module.gke_cluster.name}\""
      duration = "60s"
      comparison = "COMPARISON_LT"
      threshold_value = 2147000000
      trigger {
          count = 1
      }
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  documentation {
    content = "The Node Allocatable Ephemeral Storage rule has generated this alert."
  }
  notification_channels = [
      "${module.gke_notification_channel.emt_email_id}",
  ]
}

resource "google_monitoring_alert_policy" "pod_volume_limit_utilization" {
  display_name = "Pod Volume Limit Utilization (80%) (for ${var.project}/${module.gke_cluster.name} by namespace)"
  combiner = "OR"
  conditions {
    display_name = "Pod Volume Limit Utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/pod/volume/utilization\" resource.type=\"k8s_pod\" resource.label.\"project_id\"=\"${var.project}\" resource.label.\"cluster_name\"=\"${module.gke_cluster.name}\""
      duration = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.80
      trigger {
          count = 1
      }
      aggregations {
        cross_series_reducer = "REDUCE_MEAN"
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["resource.label.namespace_name"]
      }
    }
  }
  documentation {
    content = "The Pod Volume Limit Utilization rule has generated this alert."
  }
  notification_channels = [
      "${module.gke_notification_channel.emt_email_id}",
  ]
}

resource "google_monitoring_alert_policy" "node_problem_count" {
  display_name = "Node Problem Count (2 for 1min)(for ${var.project}/${module.gke_cluster.name})"
  combiner = "OR"
  conditions {
    display_name = "Node Problem Count"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/guest/system/problem_count\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.project}\""
      duration = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 2.0
      trigger {
          count = 1
      }
      aggregations {
        alignment_period = "60s"
        cross_series_reducer = "REDUCE_MAX"
        per_series_aligner = "ALIGN_RATE"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  }
  documentation {
    content = "The Node Problem Count rule has generated this alert."
  }
  notification_channels = [
      "${module.gke_notification_channel.emt_email_id}",
  ]
}
