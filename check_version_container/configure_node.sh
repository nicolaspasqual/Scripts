#!/bin/bash

#CRIANDO DIRETORIOS NECESSARIOS
if [ ! -d "/etc/default" ]; then
mkdir /etc/default
fi

#CONFIGURANDO ARQUIVO ENV NODE EXPORTER E PERMISSOES
cp -R env-node-exporter /etc/default/
chown -R node_exporter:node_exporter /etc/default/env-node-exporter

#CONFIGURANDO NODE EXPORTER SERVICE E PERMISSOES
cp -R node_exporter.service /etc/systemd/system/
chown -R node_exporter:node_exporter /etc/systemd/system/node_exporter.service

systemctl restart node_exporter
systemctl daemon-reload
systemctl restart node_exporter
systemctl status node_exporter