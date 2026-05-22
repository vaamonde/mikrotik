# 2024-01-21 09:11:04 by RouterOS 7.10.2
# software id = BXF7-FEAZ
#
# CRIA A INTERFACE LIST WAN
/interface list add name=WAN
/interface list add name=LAN
/interface list member add interface=ether1 list=WAN
/interface list member add interface=ether2 list=WAN
#
# REGRAS DO FIREWALL FILTER
/ip firewall filter add action=drop chain=forward comment="==============  IMPEDE WIFI VISITANTES DE ACESSAR A REDE LAN ============" dst-address=10.7.7.0/24 src-address=10.50.50.0/24
/ip firewall filter add action=accept chain=input comment="=============== ESTABELECIDAS E RELACIONADAS ===================" connection-state=established,related,untracked
/ip firewall filter add action=drop chain=input comment="============= INVALIDO ======================" connection-state=invalid
/ip firewall filter add action=add-src-to-address-list address-list=PORTSCAN address-list-timeout=4w2d chain=input comment="================ PEGA MALANDRO ============" dst-port=20-25,3389 protocol=tcp
/ip firewall filter add action=add-src-to-address-list address-list=PORTSCAN address-list-timeout=1w chain=input protocol=tcp psd=21,3s,3,1
/ip firewall filter add action=accept chain=input comment="================ WINBOX ============================" dst-port=8291 protocol=tcp
/ip firewall filter add action=accept chain=input comment="======================= ACEITA ICMP ================" limit=50,5:packet protocol=icmp
/ip firewall filter add action=drop chain=input comment="================= DROP GERAL WAN ====================" in-interface-list=WAN
/ip firewall filter add action=drop chain=CONTROLE-CONTEUDO comment="================== YOUTUBE =========" content=youtube.com
/ip firewall filter add action=drop chain=CONTROLE-CONTEUDO comment="================= facebook =================" content=facebook.com
/ip firewall filter add action=jump chain=forward comment="=== SE FOR FUNCIONARIO JUMP CONTROLE DE CONTEUDO =-" jump-target=CONTROLE-CONTEUDO src-address=10.7.7.0/24
/ip firewall filter add action=fasttrack-connection chain=forward comment="================= FASTTRACK ===============" connection-state=established,related hw-offload=yes
/ip firewall filter add action=accept chain=forward connection-state=established,related
# REGRAS DO NAT
/ip firewall nat add action=masquerade chain=srcnat comment="=========== NAT MASQUERADE WAN ==============" out-interface-list=WAN

# DROP PORT SCAN NA RAW
/ip firewall raw add action=drop chain=prerouting comment="=============== DROP HACKERS ===============" src-address-list=PORTSCAN
