variable "project" {
  description = "The name of the GCP Project where all resources will be launched."
  type        = string
}

variable "display_name" {
  description = "The display name of the notification channel."
  type        = string
}

variable "notification_channel_type" {
  description = "The type of notification channel. Can be 'email' (or (determine string value for) SMS, PagerDuty, HipChat, Slack (or use webhook to call a service you define))."
  type        = string
}

variable "cluster_emt_email" {
  description = "The email address for the Cluster EMT."
  type        = string
}
