output "emt_email_id" {
  description = "The id attached to an Alert Policy definining how/where to send the alert."
  value       = "${google_monitoring_notification_channel.cluster_emt.name}"
}
