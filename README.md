# Automated Web Server Setup with NGINX and Certbot

## Description:

This script automates the process of setting up NGINX web server, installing Node.js, cloning a repository, installing dependencies, building the project, and configuring SSL with Cerbot.

## Requirements

- Ubuntu 22.04 LTS
- nginx
- node.js (installed via nvm)
- Git
- Certbot for SSL certification

## Setup instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/Rusik-test/demo.git
   cd demo
   ```

2. Replace my email `danyakid2005@gmail.com` with your (9 step):

   ```bash
   sudo certbot --nginx -d gerty.fun -d www.gerty.fun --non-interactive --agree-tos -m danyakid2005@email.com
   ```

3. In the `setup.sh` file, replace `gerty.fun` with your domain (7 and 9 steps):

   ```bash
   server_name gerty.fun www.gerty.fun
   ```

4. Run the setup.sh script for automatic setup:

   ```
   ./setup.sh
   ```

## SSL Setup

The script will automatically set up SSL using Certbot for the provided domains. The certificates will be stored in /etc/letsencrypt.

## Usage

After successfully running the script, the website will be available at the specified domain. You can check the status of the web server with the following command:

    ```bash
    sudo systemctl status nginx
    ```

## Technical Details

This project uses Node.js for the frontend and NGINX for reverse proxy and deployment.
