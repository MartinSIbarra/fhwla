run-ddns-updater: set-tree-folders rm-ddns-updater
	docker run -dit \
		--name ddns-updater \
		--hostname ddns-updater \
		-v ./params:/root/params \
		-v ./logs:/root/logs \
		ddns-updater:alpine

rm-ddns-updater:
	docker rm -f ddns-updater 2>/dev/null || true

set-tree-folders:
	[ -e params ] || ln -s ../../z.params params
