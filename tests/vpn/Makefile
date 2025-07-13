run-vpn-server: rm-vpn-server
	docker run -dit \
		--name vpn-server \
		--hostname vpn-server \
		-v ./config:/root/config \
		-v ./params:/root/params \
		-v ./logs:/root/logs \
		-p 51820:51820/udp \
		--cap-add=NET_ADMIN \
		--device /dev/net/tun \
		vpn-server:alpine

it-vpn-server:
	docker exec -it vpn-server bash

rm-vpn-server:
	docker rm -f vpn-server 2>/dev/null || true

test-vpn-server-init:
	./bin/vpn-server-init.sh

set-tree-folders:
	[ -e params ] || ln -s ../../z.params params
