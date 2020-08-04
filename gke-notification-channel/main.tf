terraform {
  required_version = ">= 0.12.7"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE NOTIFICATION CHANNEL
# ----------------------------------------------------------------------------------------------------------------------
resource "google_monitoring_notification_channel" "cluster_emt" {
  project      = var.project
  display_name = var.display_name
  type         = var.notification_channel_type
  labels = {
    email_address = var.cluster_emt_email
  }
}
