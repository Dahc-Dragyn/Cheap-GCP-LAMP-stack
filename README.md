# LAMP Stack on Google Compute Engine

This Terraform configuration deploys a basic LAMP (Linux, Apache, MySQL, PHP) stack on a Google Compute Engine virtual machine.

## Resources

* **VPC Network:** Creates a VPC network named "lamp-network" with auto-created subnetworks disabled.
* **Subnet:** Creates a subnet named "lamp-subnet" within the VPC network, using the IP CIDR range 10.128.0.0/20.
* **Firewall Rules:**
    * `allow-http`: Allows incoming HTTP traffic on port 80 to instances with the tag "http-server".
    * `allow-https`: Allows incoming HTTPS traffic on port 443 to instances with the tag "http-server".
* **Compute Engine Instance:**
    * Creates a VM instance named "lamp-server" using the `e2-micro` machine type (cheapest general-purpose option).
    * Uses a Debian 11 image for the operating system.
    * Attaches the instance to the "lamp-subnet" subnet.
    * Includes a startup script to install Apache, MySQL, and PHP during instance creation.

## Usage

1. **Replace Placeholders:**
   * Update `your-project-id` with your actual Google Cloud project ID.
   * Adjust the `region` and `zone` if needed.

2. **Initialize Terraform:**
   ```bash
   terraform init
