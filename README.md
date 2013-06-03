iGEM Bricklayer
===============

Layin ma bricks!

### First Run

If this is your first run of the server, we have to make sure the dependencies are installed:

1. Install node.js! This will come with an executable called `npm` (Node Package Manager) that we'll use to install the dependencies.
2. Install `node-supervisor` with `npm install -g supervisor`. This supervisor app will automatically restart the server whenever a file in the project changes. Makes developping a little smoother.
3. Make sure you're in the same directory as `packages.json` and run `npm install`. This will install dependencies like express (our webserver), jade (an html template language), etc. into our project in the node_modules folder.

### Start App

To start the server do
`make go`

Visit http://localhost:3000/ in your browser to see the app.
See the `Makefile` to add more targets as you see fit.
