# PNP-X Server Setup Script

This is the setup script for PNP-X, the server portion of our proxy network management solution. 

https://proxynetworkpro.com

You'll need to replace a few things in the script.

```'MY_LICENSE_KEY'``` should be replaced with your PNP license key.

```'SERVER_SUB_DOMAIN'``` should be replaced with the subdomain name that will point to your server if you are
using DNS. Otherwise just leave it as it.

Replace the sample firebase service account credentials with your own.

```
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
```

Run the script on your server and you're good to go.

Tested on Ubuntu 18.04

PNP-X will be updated automatically whenever an update is available.