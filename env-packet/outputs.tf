output "instance_ips" {
  value = packet_device.jmeter.*.network.0.address
}
