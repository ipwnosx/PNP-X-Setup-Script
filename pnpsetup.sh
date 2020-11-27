#!/bin/bash

# this is the script that will be used to set up pnp_proxy on a server

# make config directory.
mkdir /pnp-config

# Replace 'MY_LICENSE_KEY' with your pnp license key
# Replace 'SERVER_SUB_DOMAIN' with the subdomain of your server if you are using DNS
cat << EOF > /pnp-config/.env
MAX_MB_BEFORE_REPORT=5
MAX_MINUTES_BEFORE_REPORT=1
FIREBASE_CREDS_PATH=/pnp-config/firebase-creds.json
LICENSE_KEY=MY_LICENSE_KEY
SUB_DOMAIN=SERVER_SUB_DOMAIN
REST_API_IP_PORT=:9100
EOF

# Replace the firebase credentials below with your own
cat << EOF > /pnp-config/firebase-creds.json
{
  "type": "service_account",
  "project_id": "my_project_id",
  "private_key_id": "g7n792lk2jk3j42l343418ty",
  "private_key": "-----BEGIN PRIVATE KEY-----\nJOLEvAIBADAfK==\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-@my-project-id.iam.gserviceaccount.com",
  "client_id": "23489328424324",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-gjnik%40my-project-id.iam.gserviceaccount.com"
}
EOF


# INSTALL DOCKER
# -------------------

# uninstall any old versions
apt-get remove docker docker-engine docker.io containerd runc

apt-get update

# Install packages to allow apt to use a repository over HTTPS
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common unattended-upgrades

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update

# install latest version of docker
apt-get -y install docker-ce docker-ce-cli containerd.io

# START WATCHTOWER
docker run -d --name watchtower --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 21600

# START PROXY
docker run -d -p 9000:9000 -p 9100:9100 --name="pnp_proxy" --restart=unless-stopped --env-file /pnp-config/.env --mount type=bind,source=/pnp-config,target=/pnp-config gcr.io/pnp-proxy/pnp-proxy:latest

# FIREWALL
ufw default deny
ufw allow 22
ufw allow 9100
ufw allow 9000
yes | ufw enable

# UNATTENDED UPGRADES

cat << EOF > /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}-security";
};
EOF

cat << EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
EOF