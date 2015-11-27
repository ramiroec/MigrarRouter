#! /bin/bash
function convertir() {
local mascara=$1
if [ $mascara = '255.255.255.252' ]; then
mascara='30'
return $mascara
fi
if [ $mascara = '255.255.255.248' ]; then
mascara='29'
return $mascara
fi
if [ $mascara = '255.255.255.240' ]; then
mascara='28'
return $mascara
fi
if [ $mascara = '255.255.255.224' ]; then
mascara='27'
return $mascara
fi
if [ $mascara = '255.255.255.192' ]; then
mascara='26'
return $mascara
fi
if [ $mascara = '255.255.255.128' ]; then
mascara='25'
return $mascara
fi
if [ $mascara = '255.255.255.0' ]; then
mascara='24'
return $mascara
fi
}

function VLAN() {
local interface=$1
for vlan in `cat cisco.txt | grep $interface. | awk -F "." '{print $2}'`
do
direccion=`cat cisco.txt | grep -v secondary|grep "$interface.$vlan$" -A4| grep address | awk '{print $3}'`
if [ -z "$direccion" ]; then
continue
else
mascara=`cat cisco.txt | grep -v secondary|grep "$interface.$vlan\$" -A4| grep address | awk '{print $4}'`
convertir $mascara
mascara=$?
desciption=`cat cisco.txt | grep -v secondary|grep "$interface.$vlan\$" -A4| grep description | awk -F " description " '{print $2}'|sed -e 's/ /_/g'`
echo "set interfaces ethernet eth0 vif $vlan address $direccion/$mascara"
echo "set interfaces ethernet eth0 vif $vlan description $desciption"
for secondary in `cat cisco.txt |grep "$interface.$vlan$" -A4| grep address |  grep secondary|awk '{print $3}'`
do
if [ -z "$secondary" ]; then
continue
else
mascara2=`cat cisco.txt | grep secondary| grep $secondary | awk '{print $4}'`
convertir $mascara2
mascara2=$?
echo "set interfaces ethernet eth0 vif $vlan address $secondary/$mascara2"
fi
done
fi
done
}
VLAN "FastEthernet0/0"
echo "set service snmp community elife"
cat cisco.txt | grep hostname | awk '{print "set system host-name " $2}'


