# cesareoaguirre
# referencia que se puede localizar en
# Genkey, create a TLS/SSL certificate the easy way
# https://fedoraproject.org/wiki/Https#openssl
echo creando key $1
if  [ "$1" -eq 0 ]
then
        echo "No hay argumentos"
        exit 1
fi
openssl genrsa -out $1.key 2048
openssl req -new -key $1.key -out $1.csr -sha512
openssl x509 -req -days 365 -in $1.csr -signkey $1.key -out $1.crt -sha512
cp "$1.crt" /etc/pki/tls/certs/
cp "$1.key" /etc/pki/tls/private/$1.key
cp "$1.csr" /etc/pki/tls/private/$1.csr
restorecon -RvF /etc/pki