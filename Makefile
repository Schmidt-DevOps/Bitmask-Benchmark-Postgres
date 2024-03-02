default:
	docker compose up -d

clean:
	[[ -f results-bitmask.txt ]] && rm results-bitmask.txt || true
	[[ -f results-boolean.txt ]] && rm results-boolean.txt || true

up:
	docker compose up -d

down:
	docker compose down

record:
	./bin/record_stats.sh
