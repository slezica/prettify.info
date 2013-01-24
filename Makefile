all: gen app modules web

gen:
	mkdir -p gen

app: app/app.iced
	iced -o gen/ -c app/app.iced

modules:
	cp -r app/node_modules gen/

watch:
	@echo "Watching app/ for changes..."
	@while true; do inotifywait app -qre modify; make; done

serve:
	@NODE_PORT="8000"; cd gen; node app.js
