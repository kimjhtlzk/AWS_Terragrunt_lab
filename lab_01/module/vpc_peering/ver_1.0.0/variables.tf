variable "vpc_peer" {
  type = list(object({
    peer_type         = string
    target_project_id = string
    name              = string
    vpc               = string
    target_vpc        = string
    other_region      = string
    accepter_dns_resolution = bool
    requester_dns_resolution = bool

  }))
}

