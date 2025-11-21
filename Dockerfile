FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    iptables \
    iproute2 \
    net-tools \
    systemd \
    && rm -rf /var/lib/apt/lists/*

# Create TUN device
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 600 /dev/net/tun

# Copy the installation script
COPY openvpn-install.sh /opt/openvpn-install.sh
RUN chmod +x /opt/openvpn-install.sh

# Set working directory
WORKDIR /opt

# Expose OpenVPN port
EXPOSE 1194/udp

CMD ["/bin/bash"]
