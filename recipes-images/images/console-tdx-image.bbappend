# Production
IMAGE_INSTALL_append = " \
    php php-cli php-cgi php-fpm \
    nginx \
    nodejs \
    nss cups libxscrnsaver \
"

# Development
IMAGE_INSTALL_append = " \
    git \
    vim \
    nodejs-npm \
"