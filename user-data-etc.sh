#!/bin/bash


MY_WALLET="WALLET_ADDRESS"
MY_WORKER=`curl http://169.254.169.254/latest/meta-data/instance-id`

cd  /home/ubuntu/
wget -O ethminer.tar.gz https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-9-linux-x86_64.tar.gz
tar xvfz ethminer.tar.gz
cd bin

cat <<EOF > mine.sh
#!/bin/bash
if pidof -x "ethminer">/dev/null; then
    echo "Mining Process running..."
else
    echo "Mining not running, Starting!"
    /home/ubuntu/bin/ethminer \
            -P stratums://$MY_WALLET.$MY_WORKER@asia1-etc.ethermine.org:5555   \
            -P stratums://$MY_WALLET.$MY_WORKER@eu1-etc.ethermine.org:5555   \
            -P stratums://$MY_WALLET.$MY_WORKER@us1-etc.ethermine.org:5555
fi
EOF

echo "*/2 * * * *  root  /home/ubuntu/bin/mine.sh >> /home/ubuntu/bin/mine.log" >> /etc/crontab
chmod +x mine.sh
./mine.sh