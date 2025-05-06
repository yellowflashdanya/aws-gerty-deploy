#!/bin/bash

# Exit on any error
set -e

# 1. === Updating the system ===
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# 2. === Install NGINX ===
echo "🌐 Installing NGINX..."
if ! command -v nginx &> /dev/null; then
    sudo apt install nginx -y
else
    echo "NGINX is already installed"
fi

# 3. === Installing NVM (Node Version Manager) ===
echo "🟢 Installing Node.js via NVM..."
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo "NVM is already installed"
fi

nvm install 22.14.0
nvm use 22.14.0

# 4. === Clone the repo ===
echo "📦 Cloning the repo..."
if ! git --version &> /dev/null; then
    echo "Git is not installed. Installing Git..."
    sudo apt install git -y
fi

git clone https://github.com/Rusik-test/demo
cd demo

# 5. === Install dependencies and build the project ===
echo "⚙️ Installing dependencies and building project..."
npm install
npm run build

# 6. === Deploy to NGINX root ===
echo "🚀 Deploying to /var/www/html..."
sudo rm -rf /var/www/html/*
sudo cp -r dist/* /var/www/html
sudo chown -R www-data:www-data /var/www/html

# 7. === Configure NGINX ===
echo "📝 Configure NGINX for domain..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name gerty.fun www.gerty.fun;

    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name gerty.fun www.gerty.fun;

    ssl_certificate /etc/letsencrypt/live/gerty.fun/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/gerty.fun/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# 8. === Restart the NGINX ===
echo "🔄 Restarting NGINX..."
sudo systemctl restart nginx
sudo systemctl status nginx

# 9. === Install and configure Certbot (SSL) ===
echo "🔧 Installing and configuring Certbot..."
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d gerty.fun -d www.gerty.fun --non-interactive --agree-tos -m danyakid2005@email.com
