variable "aws_region" {
  description = "The AWS region to use"
  default     = "eu-west-2"
}

variable "shared_credentials_files" {
  type        = list(string)
  description = "The location of the AWS shared credentials files (e.g. ['~/.aws/credentials'])"
}

variable "profile" {
  description = "The profile to use"
}

variable "tag_name" {
  description = "The name to tag AWS resources with"
  default     = "OpenVPN"
}

variable "cidr_block" {
  description = "The CIDR block range to use for the OpenVPN VPC"
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "The instance type to use"
  default     = "t3.micro"
}

variable "instance_root_block_device_volume_size" {
  description = "The size of the root block device volume of the EC2 instance in GiB"
  default     = 8
}

variable "ec2_username" {
  description = "The user to connect to the EC2 as"
  default     = "ec2-user"
}

variable "openvpn_install_script_location" {
  description = "The location of an OpenVPN installation script compatible with https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh"
  default     = "https://raw.githubusercontent.com/dumrauf/openvpn-install/master/openvpn-install.sh"
}

variable "ssh_public_key_file" {
  # Generate via 'ssh-keygen -f openvpn -t rsa'
  description = "The public SSH key to store in the EC2 instance"
  default     = "settings/openvpn.pub"
}

variable "ssh_private_key_file" {
  # Generate via 'ssh-keygen -f openvpn -t rsa'
  description = "The private SSH key used to connect to the EC2 instance"
  default     = "settings/openvpn"
}

variable "ovpn_users" {
  type        = list(string)
  description = "The list of users to automatically provision with OpenVPN access"
}

variable "ovpn_config_directory" {
  description = "The name of the directory to eventually download the OVPN configuration files to"
  default     = "generated/ovpn-config"
}

variable "schedule_tag_key" {
  description = "EC2 tag key used to select instances for a schedule"
  type        = string
  default     = "Schedule"
}

variable "schedules" {
  description = <<EOT
Map of schedules. Each item creates two SSM associations (start/stop) targeting
instances with tag "<schedule_tag_key>=<tag_value>".
Times are CRON in *UTC* because SSM State Manager uses UTC only.
EOT
  type = map(object({
    tag_value  : string
    start_cron : string  # e.g., "cron(0 19 ? * MON-FRI *)"
    stop_cron  : string  # e.g., "cron(0 07 ? * MON-FRI *)"
    enabled    : optional(bool, true)
  }))
  default = {
    china_daytime = {
      tag_value  = "china-daytime"
      # Example for 08:00–24:00 Pacific/Beijing during CST (UTC+8):
      # 08:30 CST => 00:30 UTC same day, 23:30 CST => 15:30 UTC same day.
      start_cron = "cron(30 0 ? * * *)" # 8:30am CST everyday
      stop_cron  = "cron(30 15 ? * * *)" # 11:30pm CST everyday
    }
  }
}
