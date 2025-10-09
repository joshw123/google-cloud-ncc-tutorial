output "EXTERNAL_LB_IP" {
  value = google_compute_address.extlb.address
}