# -------------------------------------------------------------------------------------
#  Create NCC hub with edge and center groups for the trust VPC network.
# -------------------------------------------------------------------------------------

// Create NCC hub in star topology
resource "google_network_connectivity_hub" "main" {
  count           = (var.configure_ncc ? 1 : 0)
  name            = "${local.prefix}panw-hub"
  preset_topology = "STAR"
}

// Create NCC center group for VM-Series
resource "google_network_connectivity_group" "center" {
  count = (var.configure_ncc ? 1 : 0)
  hub   = google_network_connectivity_hub.main[0].id
  name  = "center"
  auto_accept {
    auto_accept_projects = [
      var.project_id
    ]
  }
}

// Create NCC edge group for VM-Series
resource "google_network_connectivity_group" "edge" {
  count = (var.configure_ncc ? 1 : 0)
  hub   = google_network_connectivity_hub.main[0].id
  name  = "edge"
  auto_accept {
    auto_accept_projects = [
      var.project_id
    ]
  }
}

# -------------------------------------------------------------------------------------
#  Create NCC spokes.
# -------------------------------------------------------------------------------------

// Create NCC spoke for trust VPC
resource "google_network_connectivity_spoke" "trust" {
  count    = (var.configure_ncc ? 1 : 0)
  name     = "${local.prefix}trust"
  location = "global"
  group    = google_network_connectivity_group.center[0].id
  hub      = google_network_connectivity_hub.main[0].id

  linked_vpc_network {
    uri = google_compute_network.trust.self_link
  }
}

// Create NCC spoke for spoke1-vpc
resource "google_network_connectivity_spoke" "spoke1" {
  count    = (var.configure_ncc ? 1 : 0)
  name     = "${local.prefix}spoke1"
  location = "global"
  group    = google_network_connectivity_group.edge[0].id
  hub      = google_network_connectivity_hub.main[0].id

  linked_vpc_network {
    uri = google_compute_network.spoke1.self_link
  }
}

// Create NCC spoke for spoke2-vpc
resource "google_network_connectivity_spoke" "spoke2" {
  count    = (var.configure_ncc ? 1 : 0)
  name     = "${local.prefix}spoke2"
  location = "global"
  group    = google_network_connectivity_group.edge[0].id
  hub      = google_network_connectivity_hub.main[0].id

  linked_vpc_network {
    uri = google_compute_network.spoke2.self_link
  }
}


