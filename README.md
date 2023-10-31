
# Easy appointments

Organize your business! Save human resources that can be used in other tasks more efficiently.



Forked from: https://github.com/alextselegidis/easyappointments-docker



## Instalação

edite o arquivo .env de acordo com as informações do seu ambiente.

```bash
VERSION="1.4.3"
BASE_URL="http://localhost"
LANGUAGE="english"
DEBUG_MODE="FALSE"
DB_HOST="mysql"
DB_ROOT_PASS="easyappointmentsrootpass"
DB_NAME="easyappointments"
DB_USERNAME="root"
DB_PASSWORD="secret"

GOOGLE_SYNC_FEATURE=FALSE
GOOGLE_PRODUCT_NAME=""
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""
GOOGLE_API_KEY=""
EMAIL_ENABLED="FALSE"
EMAIL_AUTH=""
EMAIL_HOST=""
EMAIL_USER=""
EMAIL_PASS=""
EMAIL_CRYPTO=""
EMAIL_PORT=""
```

Rode o comando:
```bash
$ docker-compose build
```

E em seguida rode o comando:
```bash
$ docker-compose up
```
    