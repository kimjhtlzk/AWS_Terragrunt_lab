resource "aws_vpc_peering_connection" "vpc_peer" {
  for_each = { for vpc_peer in var.vpc_peer : vpc_peer.name => vpc_peer }

  peer_owner_id = each.value.peer_type == "internal" ? null : each.value.target_project_id

  tags = {
    Name = each.value.name
  }
  vpc_id        = each.value.vpc
  peer_vpc_id   = each.value.target_vpc
  peer_region   = each.value.other_region
  auto_accept   = each.value.other_region == null && each.value.peer_type == "internal" ? true : null
  
  accepter {
    allow_remote_vpc_dns_resolution = each.value.accepter_dns_resolution
  }

  requester {
    allow_remote_vpc_dns_resolution = each.value.requester_dns_resolution
  }


}


  
