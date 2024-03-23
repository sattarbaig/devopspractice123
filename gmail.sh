#!/bin/bash
yum update -y --exclude=kernel*
yum -y install postfix cyrus-sasl-plain mailx
systemctl restart postfix 
systemctl enable postfix 
vi /etc/postfix/main.cf 
cat <<EOF >> /etc/postfix/main.cf
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
EOF

touch /etc/postfix/sasl_passwd  
cat <<EOF >> /etc/postfix/sasl_passwd
[smtp.gmail.com]:587 sattarbaig786@gmail.com@hosz dgtk wbxi meyp
EOF

postmap /etc/postfix/sasl_passwd 
echo "This is a test mail & Date $(date)" | mail -s "message" sattarbaig786@gmail.com


