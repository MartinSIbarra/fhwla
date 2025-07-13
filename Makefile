.PHONY: \
	build-all \
	build-tunnel-server \
	build-vpn-server \
	build-proxy-server \
	build-ddns-updater \
	build-fake-app \
	rm-tunnel-server \
	rm-vpn-server \
	rm-proxy-server \
	rm-ddns-updater \
	rm-fake-app \
	push-tunnel-server \
	push-vpn-server \
	push-proxy-server \
	push-ddns-updater \
	push-fake-app

clean-images:
	docker rmi -f \
		tunnel-server:alpine \
		vpn-server:alpine \
		proxy-server:alpine \
		ddns-updater:alpine \
		fake-app:alpine \
	docker builder prune -f

build-all: \
	build-tunnel-server \
	build-vpn-server \
	build-proxy-server \
	build-ddns-updater \
	build-fake-app 

build-tunnel-server: rm-tunnel-server
	./common/helpers/build.sh "tunnel-server" "alpine"

push-tunnel-server:
	./common/helpers/push.sh "tunnel-server" "alpine"

rm-tunnel-server:
	docker rm -f tunnel-server 2>/dev/null || true

build-vpn-server: rm-vpn-server
	./common/helpers/build.sh "vpn-server" "alpine"

push-vpn-server:
	./common/helpers/push.sh "vpn-server" "alpine"

rm-vpn-server:
	docker rm -f vpn-server 2>/dev/null || true

build-proxy-server: rm-proxy-server
	./common/helpers/build.sh "proxy-server" "alpine"

push-proxy-server:
	./common/helpers/push.sh "proxy-server" "alpine"

rm-proxy-server:
	docker rm -f proxy-server 2>/dev/null || true

build-ddns-updater: rm-ddns-updater
	./common/helpers/build.sh "ddns-updater" "alpine"

push-ddns-updater:
	./common/helpers/push.sh "ddns-updater" "alpine"

rm-ddns-updater:
	docker rm -f ddns-updater 2>/dev/null || true

build-fake-app: rm-fake-app
	./common/helpers/build.sh "fake-app" "alpine"

rm-fake-app:
	docker rm -f fake-app 2>/dev/null || true

push-fake-app:
	./common/helpers/push.sh "fake-app" "alpine"

