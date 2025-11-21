# OpenVPN Road Warrior Installer

An automated bash script to install and manage OpenVPN server with road warrior configuration on Linux servers.

## Overview

This script provides a straightforward, interactive way to set up an OpenVPN server that allows multiple clients (road warriors) to connect securely to your network. It handles the complete setup process including certificate generation, firewall configuration, and client management.

## Supported Operating Systems

- **Ubuntu** 22.04 or higher
- **Debian** 11 or higher
- **AlmaLinux** 9 or higher
- **Rocky Linux** 9 or higher
- **CentOS** 9 or higher
- **Fedora** (latest versions)

## Prerequisites

- Root or sudo access
- TUN device available (required for VPN)
- Server must have a public IP address or be accessible via port forwarding
- At least one network interface with an IPv4 address

## Features

### Initial Installation

- Automatic OS detection and validation
- Interactive setup wizard
- IPv4 and IPv6 support
- Choice of UDP or TCP protocol
- Custom port configuration
- Multiple DNS provider options
- Automatic firewall configuration (firewalld or iptables)
- Certificate and key generation using Easy-RSA
- First client configuration generation

### Client Management

- Add new clients
- Revoke existing clients
- Generate `.ovpn` configuration files
- Certificate validity: 10 years

### Security Features

- SHA512 authentication
- TLS encryption with tls-crypt
- DH parameters using ffdhe2048 group
- Certificate-based client authentication
- CRL (Certificate Revocation List) support

## Installation

### 1. Download the Script

```bash
wget https://raw.githubusercontent.com/xdev-asia-labs/openvpn-install/main/openvpn-install.sh
chmod +x openvpn-install.sh
```

Or clone the repository:

```bash
git clone https://github.com/xdev-asia-labs/openvpn-install.git
cd openvpn-install
chmod +x openvpn-install.sh
```

### 2. Run the Script

```bash
sudo bash openvpn-install.sh
```

## Usage Guide

### First-Time Setup

When you run the script for the first time, it will guide you through the installation process:

#### 1. IP Address Selection

The script automatically detects your server's IPv4 address. If multiple addresses are found, you'll be prompted to select one.

#### 2. NAT Configuration

If your server is behind NAT (private IP), you'll need to provide your public IP address or hostname:

```
This server is behind NAT. What is the public IPv4 address or hostname?
Public IPv4 address / hostname [auto-detected-ip]:
```

#### 3. IPv6 Configuration (Optional)

If IPv6 is available, the script will detect and configure it automatically.

#### 4. Protocol Selection

Choose between UDP (recommended) or TCP:

```
Which protocol should OpenVPN use?
   1) UDP (recommended)
   2) TCP
Protocol [1]:
```

**Recommendation:** Use UDP for better performance unless your network blocks UDP traffic.

#### 5. Port Configuration

Choose the port for OpenVPN to listen on:

```
What port should OpenVPN listen on?
Port [1194]:
```

**Default:** 1194 (standard OpenVPN port)

#### 6. DNS Server Selection

Select a DNS provider for VPN clients:

```
Select a DNS server for the clients:
   1) Default system resolvers
   2) Google
   3) 1.1.1.1
   4) OpenDNS
   5) Quad9
   6) Gcore
   7) AdGuard
   8) Specify custom resolvers
DNS server [1]:
```

**Options:**

- **Option 1:** Uses your server's DNS resolvers
- **Option 2:** Google DNS (8.8.8.8, 8.8.4.4)
- **Option 3:** Cloudflare DNS (1.1.1.1, 1.0.0.1)
- **Option 4:** OpenDNS (208.67.222.222, 208.67.220.220)
- **Option 5:** Quad9 (9.9.9.9, 149.112.112.112)
- **Option 6:** Gcore (95.85.95.85, 2.56.220.2)
- **Option 7:** AdGuard (94.140.14.14, 94.140.15.15)
- **Option 8:** Custom DNS servers

#### 7. First Client Name

Enter a name for the first client:

```
Enter a name for the first client:
Name [client]:
```

**Note:** Only alphanumeric characters, underscores, and hyphens are allowed.

#### 8. Complete Installation

Press any key to begin the installation. The script will:

- Install required packages (OpenVPN, Easy-RSA, firewall tools)
- Generate certificates and keys
- Configure the server
- Set up firewall rules
- Enable IP forwarding
- Start the OpenVPN service

### Post-Installation

After successful installation, you'll see:

```
Finished!

The client configuration is available in: /path/to/client.ovpn
New clients can be added by running this script again.
```

### Managing Clients

Run the script again to access the management menu:

```bash
sudo bash openvpn-install.sh
```

You'll see:

```
OpenVPN is already installed.

Select an option:
   1) Add a new client
   2) Revoke an existing client
   3) Remove OpenVPN
   4) Exit
Option:
```

#### Option 1: Add a New Client

1. Select option 1
2. Enter a unique client name
3. The script generates a new `.ovpn` configuration file
4. Download the `.ovpn` file to your client device

#### Option 2: Revoke an Existing Client

1. Select option 2
2. Choose the client from the list
3. Confirm revocation
4. The client's certificate will be revoked and added to the CRL

**Note:** Revoked clients will no longer be able to connect to the VPN.

#### Option 3: Remove OpenVPN

Completely uninstalls OpenVPN and removes all configuration:

1. Select option 3
2. Confirm removal with 'y'
3. All OpenVPN files, configurations, and firewall rules will be removed

#### Option 4: Exit

Exit the script without making changes.

## Client Configuration

### Distributing .ovpn Files

After generating client configurations, you'll find `.ovpn` files in the script directory. These files contain everything needed for a client to connect:

- Client certificate
- Private key
- CA certificate
- Server connection details
- TLS authentication key

### Connecting Clients

#### Windows

1. Install [OpenVPN GUI](https://openvpn.net/community-downloads/)
2. Copy the `.ovpn` file to `C:\Program Files\OpenVPN\config\`
3. Right-click the OpenVPN GUI icon and connect

#### macOS

1. Install [Tunnelblick](https://tunnelblick.net/) or [OpenVPN Connect](https://openvpn.net/client-connect-vpn-for-mac-os/)
2. Double-click the `.ovpn` file to import
3. Connect through the application

#### Linux

```bash
sudo openvpn --config client.ovpn
```

Or use NetworkManager:

```bash
sudo nmcli connection import type openvpn file client.ovpn
```

#### iOS

1. Install [OpenVPN Connect](https://apps.apple.com/app/openvpn-connect/id590379981)
2. Transfer the `.ovpn` file to your device
3. Import and connect

#### Android

1. Install [OpenVPN for Android](https://play.google.com/store/apps/details?id=de.blinkt.openvpn)
2. Transfer the `.ovpn` file to your device
3. Import and connect

## Network Configuration

### VPN Network Details

- **IPv4 Subnet:** 10.8.0.0/24
- **IPv6 Subnet:** fddd:1194:1194:1194::/64 (if IPv6 is enabled)
- **VPN Gateway:** 10.8.0.1
- **IP Pool:** 10.8.0.2 - 10.8.0.254

### Firewall Configuration

The script automatically configures firewall rules:

**Using firewalld:**

- Adds OpenVPN port to allowed ports
- Adds VPN subnet to trusted zone
- Configures NAT/masquerading

**Using iptables:**

- Creates systemd service for persistent rules
- Allows OpenVPN port
- Enables forwarding for VPN subnet
- Configures SNAT for internet access

### Port Forwarding (NAT Setup)

If your server is behind NAT, configure your router to forward the chosen port (default 1194) to your server's internal IP address.

## Troubleshooting

### Check OpenVPN Service Status

```bash
sudo systemctl status openvpn-server@server
```

### View OpenVPN Logs

```bash
sudo journalctl -u openvpn-server@server -f
```

### Verify Firewall Rules

**firewalld:**

```bash
sudo firewall-cmd --list-all
```

**iptables:**

```bash
sudo iptables -t nat -L -n -v
sudo iptables -L -n -v
```

### Check IP Forwarding

```bash
cat /proc/sys/net/ipv4/ip_forward
```

Should return `1`

### Common Issues

#### Issue: Client can connect but has no internet access

- **Solution:** Check firewall NAT rules and IP forwarding

#### Issue: Connection timeout

- **Solution:** Verify port forwarding if behind NAT, check firewall allows the OpenVPN port

#### Issue: DNS not working

- **Solution:** Check DNS configuration in `/etc/openvpn/server/server.conf`

#### Issue: TUN device not available

- **Solution:** Enable TUN/TAP in your VPS control panel (common in OpenVZ containers)

## File Locations

### Server Configuration

- **Main config:** `/etc/openvpn/server/server.conf`
- **CA certificate:** `/etc/openvpn/server/ca.crt`
- **Server certificate:** `/etc/openvpn/server/server.crt`
- **Server key:** `/etc/openvpn/server/server.key`
- **TLS key:** `/etc/openvpn/server/tc.key`
- **CRL:** `/etc/openvpn/server/crl.pem`
- **DH parameters:** `/etc/openvpn/server/dh.pem`

### Easy-RSA PKI

- **PKI directory:** `/etc/openvpn/server/easy-rsa/pki/`
- **Client certificates:** `/etc/openvpn/server/easy-rsa/pki/issued/`
- **Private keys:** `/etc/openvpn/server/easy-rsa/pki/private/`

### Client Configurations

- **Generated .ovpn files:** Script directory (where you ran the script)
- **Client template:** `/etc/openvpn/server/client-common.txt`

## Security Considerations

### Best Practices

1. **Keep certificates secure:** Never share server keys or CA private key
2. **Use strong client names:** Avoid generic names like "client1"
3. **Regular key rotation:** Consider regenerating certificates periodically
4. **Revoke compromised certificates immediately:** Use option 2 in the management menu
5. **Secure .ovpn files:** Protect client configuration files as they contain private keys
6. **Use UDP when possible:** Better performance and harder to detect
7. **Change default port:** Consider using a non-standard port for additional obscurity
8. **Enable logging:** Monitor connection attempts and successful connections
9. **Update regularly:** Keep OpenVPN and system packages up to date

### Firewall Security

- The script only opens the necessary OpenVPN port
- VPN clients are isolated from local network by default
- All VPN traffic is encrypted and authenticated

## Advanced Configuration

### Custom Server Settings

Edit `/etc/openvpn/server/server.conf` to customize:

```bash
sudo nano /etc/openvpn/server/server.conf
```

After making changes, restart the service:

```bash
sudo systemctl restart openvpn-server@server
```

### Increase Verbosity for Debugging

Change `verb 3` to `verb 4` or `verb 5` in `server.conf`

### Allow Client-to-Client Communication

Add this line to `server.conf`:

```
client-to-client
```

### Push Routes to Clients

To route specific networks through VPN:

```
push "route 192.168.1.0 255.255.255.0"
```

### Split Tunnel Configuration

To avoid routing all traffic through VPN (split tunnel), remove or comment out:

```
push "redirect-gateway def1 bypass-dhcp"
```

And add specific routes instead.

## Performance Tuning

### Optimize for Speed

Add these directives to `server.conf`:

```
sndbuf 393216
rcvbuf 393216
push "sndbuf 393216"
push "rcvbuf 393216"
```

### Adjust Cipher

For better performance (with slightly less security):

```
cipher AES-128-GCM
auth SHA256
```

## Uninstallation

To completely remove OpenVPN:

1. Run the script:

   ```bash
   sudo bash openvpn-install.sh
   ```

2. Select option 3 (Remove OpenVPN)

3. Confirm with 'y'

This will:

- Stop the OpenVPN service
- Remove all configuration files
- Remove firewall rules
- Uninstall OpenVPN package
- Remove IP forwarding configuration

## Credits

- Forked and maintained by xdev-asia-labs

## License

MIT License - See the script header for full license text

## Support

For issues, questions, or contributions:

- **GitHub Issues:** <https://github.com/xdev-asia-labs/openvpn-install/issues>
- **Pull Requests:** Contributions are welcome!

## Changelog

### Features

- Easy interactive installation
- Support for major Linux distributions
- IPv6 support
- Multiple DNS provider options
- Automatic firewall configuration
- Client management (add/revoke)
- Long-lived certificates (10 years)
- SELinux support
- Container detection and optimization

## FAQ

**Q: Can I run this in a container?**
A: Yes, the script detects container environments and adjusts configuration accordingly.

**Q: How many clients can I add?**
A: The default subnet allows 254 clients. You can modify this in the server configuration.

**Q: Can I change the port after installation?**
A: Yes, edit `/etc/openvpn/server/server.conf`, update firewall rules, and restart the service.

**Q: Is this suitable for production?**
A: Yes, the script uses industry-standard security practices and is widely used in production environments.

**Q: Can I use my own certificates?**
A: The script is designed to generate its own certificates. Manual certificate management would require modifying the script.

**Q: How do I backup my configuration?**
A: Backup the entire `/etc/openvpn/server/` directory and your `.ovpn` files.

**Q: Can clients access my local network?**
A: By default, no. Clients can only access the internet through the VPN. You can add routes to allow local network access.

**Q: What if I lose a .ovpn file?**
A: You can regenerate it by adding the same client name again (first revoke the old certificate if you're concerned about security).

---

**Last Updated:** November 2025
