cat << EOF >> ../static_inventory
[jenkins_server]
%{ for ip in amazon ~}
${ip}
%{ endfor ~}