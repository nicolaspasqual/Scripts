docker run -d --name=node_exporter \
--restart=always \
-m 1024m --cpu-period=100000 --cpu-quota=50000 \
--net="host" --pid="host" \
-v "/:/host:ro" \
-v "/home/nicolas/arquivos/node-exporter/arquivos:/var/lib/prometheus/node-exporter" \
quay.io/prometheus/node-exporter:v1.1.2 --path.rootfs=/host --collector.textfile.directory=/var/lib/prometheus/node-exporter/