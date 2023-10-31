#!/bin/sh

# -----------------------------------------------------------------------------
# Easy!Appointments - Online Appointment Scheduler
#
# @package     EasyAppointments
# @author      A.Tselegidis <alextselegidis@gmail.com>
# @copyright   Copyright (c) Alex Tselegidis
# @license     https://opensource.org/licenses/GPL-3.0 - GPLv3
# @link        https://easyappointments.org
# -----------------------------------------------------------------------------

##
# Set up the currently cloned Easy!Appointments build.
#
# This script will perform the required actions so that Easy!Appointments is configured properly to work with the
# provided environment variables.
#
# Usage:
#
#  ./docker-entrypoint.sh
#
email_file="./application/config/email.php"

cp config-sample.php config.php

sed -i "s|const BASE_URL      = 'http://url-to-easyappointments-directory';|const BASE_URL      = '$BASE_URL';|g" config.php
sed -i "s|const LANGUAGE      = 'english';|const LANGUAGE      = '$LANGUAGE';|g" config.php
sed -i "s|const DEBUG_MODE    = FALSE;|const DEBUG_MODE    = $DEBUG_MODE;|g" config.php

sed -i "s|const DB_HOST       = 'localhost';|const DB_HOST       = '$DB_HOST';|g" config.php
sed -i "s|const DB_NAME       = 'easyappointments';|const DB_NAME       = '$DB_NAME';|g" config.php
sed -i "s|const DB_USERNAME   = 'root';|const DB_USERNAME   = '$DB_USERNAME';|g" config.php
sed -i "s|const DB_PASSWORD   = 'root';|const DB_PASSWORD   = '$DB_PASSWORD';|g" config.php

sed -i "s|const GOOGLE_SYNC_FEATURE   = FALSE;|const GOOGLE_SYNC_FEATURE       = '$GOOGLE_SYNC_FEATURE';|g" config.php
sed -i "s|const GOOGLE_PRODUCT_NAME   = '';|const GOOGLE_PRODUCT_NAME   = '$GOOGLE_GOOGLE_PRODUCT_NAME';|g" config.php
sed -i "s|const GOOGLE_CLIENT_ID      = '';|const GOOGLE_CLIENT_ID      = '$GOOGLE_CLIENT_ID';|g" config.php
sed -i "s|const GOOGLE_CLIENT_SECRET  = '';|const GOOGLE_CLIENT_SECRET  = '$GOOGLE_CLIENT_SECRET';|g" config.php
sed -i "s|const GOOGLE_API_KEY        = '';|const GOOGLE_API_KEY        = '$GOOGLE_API_KEY';|g" config.php


# Verificar o valor da variável $EMAIL_ENABLED
if [ "$EMAIL_ENABLED" = "TRUE" ]; then
    # Executar a substituição no arquivo email.php usando sed
    sed -i "s|\$config\['useragent'\].*|\$config['useragent'] = 'Easy!Appointments';|" "$email_file"
    #'TRUE'; // or 'FALSE'
    sed -i "s|\$config\['protocol'\].*|\$config['protocol'] = 'smtp';|" "$email_file"
    sed -i "s|\$config\['mailtype'\].*|\$config['mailtype'] = 'html';|" "$email_file"
    #'TRUE'; // or 'FALSE'
    sed -i "s|// \$config\['smtp_debug'\] = '0';|\$config['smtp_debug'] = '0';|" "$email_file" 
    sed -i "s|// \$config\['smtp_auth'\] = TRUE;|\$config['smtp_auth'] = '$EMAIL_AUTH';|" "$email_file" 
    sed -i "s|// \$config\['smtp_host'\] = '';|\$config['smtp_host'] = '$EMAIL_HOST';|" "$email_file"
    sed -i "s|// \$config\['smtp_user'\] = '';|\$config[\'smtp_user\'] = '$EMAIL_USER';|" "$email_file"
    sed -i "s|// \$config\['smtp_pass'\] = '';|\$config['smtp_pass'] = '$EMAIL_PASS';|" "$email_file"
    # ssl ou 'tls'
    sed -i "s|// \$config\['smtp_crypto'\] = 'ssl'; // or 'tls'|\$config['smtp_crypto'] = '$EMAIL_CRYPTO';|" "$email_file"
    # 465 ou 2465
    sed -i "s|// \$config\['smtp_port'\] = 25;|\$config['smtp_port'] = '$EMAIL_PORT';|" "$email_file"
    #cat application/config/email.php
    echo "Substituição realizada em email.php"
else
    echo "A variável EMAIL_ENABLED não é igual a TRUE. Nenhuma substituição realizada."
fi


apache2-foreground
