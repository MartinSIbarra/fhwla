run-tunnel-server: \
	create-proxy-net \
	rm-tunnel-server \
	do-tunnel-server-run \
	run-proxy-server 

run-proxy-server: \
	create-proxy-net \
	rm-proxy-server \
	do-proxy-server-run \
	rm-fake-prod-app \
	run-fake-prod-app \
	rm-fake-uat-app \
	run-fake-uat-app \
	connect-proxy-prod-net \
	connect-proxy-uat-net 

do-tunnel-server-run: create-proxy-net
	docker run -dit \
		--name tunnel-server \
		--hostname tunnel-server \
		-v ./params:/root/params \
		-v ./logs:/root/logs \
		--network proxy-net \
		tunnel-server:alpine

rm-tunnel-server: 
	docker rm -f tunnel-server 2>/dev/null || true

do-proxy-server-run: create-proxy-net create-prod-net create-uat-net
	docker run -dit \
		--name proxy-server \
		--hostname proxy-server \
		-v ./params:/root/params \
		-v ./config:/root/config \
		-v ./logs:/root/logs \
		--network proxy-net \
		proxy-server:alpine

rm-proxy-server: 
	docker rm -f proxy-server 2>/dev/null || true

run-fake-prod-app: create-prod-net rm-fake-prod-app
	docker run -dit \
		--name prod-app \
		--hostname prod-app \
		--network prod-net \
		fake-app:alpine

rm-fake-prod-app:
	docker rm -f prod-app 2>/dev/null || true

run-fake-uat-app: create-uat-net rm-fake-uat-app
	docker run -dit \
		--name uat-app \
		--hostname uat-app \
		--network uat-net \
		fake-app:alpine

rm-fake-uat-app:
	docker rm -f uat-app 2>/dev/null || true

proxy-run-bash:
	docker exec -it proxy-server bash

connect-proxy-prod-net:
	docker network connect prod-net proxy-server 2>/dev/null || true

connect-proxy-uat-net:
	docker network connect uat-net proxy-server 2>/dev/null || true

create-proxy-net:
	docker network create proxy-net 2>/dev/null || true

create-prod-net:
	docker network create prod-net 2>/dev/null || true

create-uat-net:
	docker network create uat-net 2>/dev/null || true

set-tree-folders:
	[ -e params ] || ln -s ../../z.params params
