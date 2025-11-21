#!/bin/bash
# Docker test script for OpenVPN installer

set -e

echo "======================================"
echo "OpenVPN Installer Docker Test"
echo "======================================"
echo ""

# Build Docker image
echo "Building Docker image..."
docker build -t openvpn-test .

echo ""
echo "======================================"
echo "Running test container..."
echo "======================================"
echo ""

# Run container with privileged mode (required for TUN device and networking)
docker run -it --rm \
    --privileged \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    -v "$(pwd)/openvpn-install.sh:/opt/openvpn-install.sh" \
    openvpn-test \
    /bin/bash -c "
        echo 'Container started successfully!'
        echo ''
        echo 'To test the installer, run:'
        echo '  bash /opt/openvpn-install.sh'
        echo ''
        echo 'For automated test (non-interactive), you can pre-configure:'
        echo '  export AUTO_INSTALL=y'
        echo '  export APPROVE_IP=y'
        echo '  export ENDPOINT=\$(ip -4 addr | grep inet | grep -vE \"127.0.0.1\" | cut -d\" \" -f6 | cut -d\"/\" -f1 | head -n1)'
        echo '  bash /opt/openvpn-install.sh'
        echo ''
        exec /bin/bash
    "
