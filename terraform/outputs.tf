output "frontend_public_ip" {
  description = "Public IPv4 address of the Nginx frontend."
  value       = module.frontend.public_ip
}

output "backend_public_ip" {
  description = "Public IPv4 address of the Netdata backend (port 19999 is not publicly allowed)."
  value       = module.backend.public_ip
}

output "frontend_instance_id" {
  description = "EC2 instance ID for the frontend."
  value       = module.frontend.instance_id
}

output "backend_instance_id" {
  description = "EC2 instance ID for the backend."
  value       = module.backend.instance_id
}

output "application_url" {
  description = "Open this URL to access Netdata through Nginx."
  value       = "http://${module.frontend.public_ip}/"
}
