all: g app modules

g:
	mkdir -p g

app: a/app.iced
	iced -o g/ -c a/app.iced

modules:
	cp -r a/node_modules g/

watch:
	@echo "Watching a/ for changes..."
	@while true; do inotifywait a -qre modify; make; done

serve:
	@NODE_PORT="8000"; cd g; node app.js
