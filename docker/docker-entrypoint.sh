#!/bin/sh

# -----------------------------------------------------------------------------
# Easy!Appointments - Online Appointment Scheduler
#
# @package     EasyAppointments
# @author      Victor Queiroga <victorqueiroga.jp.com>
# @copyright   Baseado no projeto de Alex Tselegidis
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
#  ./docker/docker-entrypoint.sh
#
mount_path="/var/www/html"

cd $mount_path

cp -f /tmp/dependencies/integrity_test.php .

if [ ! -d "./application" ] || [ ! "$(ls -A ./application)" ]; then 
    echo "1. ---=== COPIANDO OS ARQUIVOS DA APLICAÇÃO ===---"
    cp -r /tmp/app/* . 
    cp -f ./config-sample.php ./config.php
    rm ./config-sample.php
    chmod -R 755 .
    chown -R www-data:www-data .    
else
    echo "1. ----- A APLICAÇÃO JÁ CONTÉM OS ARQUIVOS DA APLICAÇÃO -----";
fi

echo "2. ---=== COPIANDO OUTRAS DEPENDÊNCIAS E CUSTOMIZAÇÕES ===---";

cp -f /tmp/dependencies/assets/css/* ./assets/css 
cp -f /tmp/dependencies/assets/img/* ./assets/img 
 
echo "..... CÓPIA DAS PEDENDÊNCIAS CONCLUÍDA";

echo "3. ---=== ALTERANDO ARQUIVO DE CONFIGURAÇÕES BASE  ===---";
sed -i "s|const BASE_URL      = 'http://url-to-easyappointments-directory';|const BASE_URL      = '$BASE_URL';|g" config.php
sed -i "s|const LANGUAGE      = 'english';|const LANGUAGE      = '$LANGUAGE';|g" config.php
sed -i "s|const DEBUG_MODE    = FALSE;|const DEBUG_MODE    = $DEBUG_MODE;|g" config.php

sed -i "s|const DB_HOST       = 'localhost';|const DB_HOST       = '$DB_HOST';|g" config.php
sed -i "s|const DB_NAME       = 'easyappointments';|const DB_NAME       = '$DB_NAME';|g" config.php
sed -i "s|const DB_USERNAME   = 'root';|const DB_USERNAME   = '$DB_USERNAME';|g" config.php
sed -i "s|const DB_PASSWORD   = 'root';|const DB_PASSWORD   = '$DB_PASSWORD';|g" config.php

sed -i "s|const GOOGLE_SYNC_FEATURE   = FALSE;|const GOOGLE_SYNC_FEATURE       = '$GOOGLE_SYNC_FEATURE';|g" config.php
sed -i "s|const GOOGLE_PRODUCT_NAME   = '';|const GOOGLE_PRODUCT_NAME   = '$GOOGLE_PRODUCT_NAME';|g" config.php
sed -i "s|const GOOGLE_CLIENT_ID      = '';|const GOOGLE_CLIENT_ID      = '$GOOGLE_CLIENT_ID';|g" config.php
sed -i "s|const GOOGLE_CLIENT_SECRET  = '';|const GOOGLE_CLIENT_SECRET  = '$GOOGLE_CLIENT_SECRET';|g" config.php
sed -i "s|const GOOGLE_API_KEY        = '';|const GOOGLE_API_KEY        = '$GOOGLE_API_KEY';|g" config.php
echo "....ALTERAÇÃO CONCLUÍDA";

email_file="./application/config/email.php"
# Verificar o valor da variável $EMAIL_ENABLED
if [ "$EMAIL_ENABLED" = "TRUE" ]; then
    echo "4. ---=== ALTERANDO ARQUIVO DE CONFIGURAÇÕES DE E-MAIL  ===---";
    # Executar a substituição no arquivo email.php usando sed
    sed -i "s|\$config\['useragent'\].*|\$config['useragent'] = 'Easy!Appointments';|" "$email_file"
    #'TRUE'; // or 'FALSE'
    sed -i "s|\$config\['protocol'\].*|\$config['protocol'] = 'smtp';|" "$email_file"
    sed -i "s|\$config\['mailtype'\].*|\$config['mailtype'] = 'html';|" "$email_file"
    #'TRUE'; // or 'FALSE'
    sed -i "s|// \$config\['smtp_debug'\] = '0';|\$config['smtp_debug'] = '0';|" "$email_file" 
    sed -i "s|// \$config\['smtp_auth'\] = TRUE;|\$config['smtp_auth'] = $EMAIL_AUTH;|" "$email_file" 
    sed -i "s|// \$config\['smtp_host'\] = '';|\$config['smtp_host'] = '$EMAIL_HOST';|" "$email_file"
    sed -i "s|// \$config\['smtp_user'\] = '';|\$config[\'smtp_user\'] = '$EMAIL_USER';|" "$email_file"
    sed -i "s|// \$config\['smtp_pass'\] = '';|\$config['smtp_pass'] = '$EMAIL_PASS';|" "$email_file"
    # ssl ou 'tls'
    sed -i "s|// \$config\['smtp_crypto'\] = 'ssl'; // or 'tls'|\$config['smtp_crypto'] = '$EMAIL_CRYPTO';|" "$email_file"
    # 465 ou 2465
    sed -i "s|// \$config\['smtp_port'\] = 25;|\$config['smtp_port'] = $EMAIL_PORT;|" "$email_file"
    #cat application/config/email.php
    echo "......SUBSTITUIÇÃO REALIZA EM 'email.php'"
else
    echo "Configuracao de email nao habilitada. Nenhuma substituição realizada."
fi

chmod -R 755 ./config.php $email_file
chown -R www-data:www-data ./config.php $email_file
chown -R www-data:www-data ./assets/* 

echo "================ MONTAGEM DO CONTEINER CONCLUÍDO ==================";

apache2-foreground
