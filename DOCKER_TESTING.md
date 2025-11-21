# Docker Testing

## Quick Test with Docker

### Option 1: Using test script (recommended)

```bash
./test-docker.sh
```

### Option 2: Using Docker Compose

```bash
# Start container
docker-compose up -d

# Access container
docker-compose exec openvpn-test /bin/bash

# Inside container, run the installer
bash /opt/openvpn-install.sh
```

### Option 3: Manual Docker commands

```bash
# Build image
docker build -t openvpn-test .

# Run container
docker run -it --rm \
    --privileged \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    -v "$(pwd)/openvpn-install.sh:/opt/openvpn-install.sh" \
    openvpn-test

# Inside container, run the installer
bash /opt/openvpn-install.sh
```

## Automated Testing

For non-interactive testing, you can use environment variables:

```bash
docker run -it --rm \
    --privileged \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    -v "$(pwd)/openvpn-install.sh:/opt/openvpn-install.sh" \
    openvpn-test \
    /bin/bash -c '
        export AUTO_INSTALL=y
        export APPROVE_IP=y
        export ENDPOINT=$(ip -4 addr | grep inet | grep -vE "127.0.0.1" | cut -d" " -f6 | cut -d"/" -f1 | head -n1)
        bash /opt/openvpn-install.sh
    '
```

## Troubleshooting

### OpenVPN service fails to start

This is normal in Docker containers because systemd is not fully functional. The script will install and configure OpenVPN, but you'll need to start it manually:

```bash
# Inside container
openvpn --config /etc/openvpn/server/server.conf &
```

### TUN device not available

Make sure you run Docker with `--privileged` and `--device=/dev/net/tun` flags.

### Network issues

Ensure the container has `--cap-add=NET_ADMIN` capability.
