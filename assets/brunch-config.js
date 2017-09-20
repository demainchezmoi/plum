exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js"
			// joinTo: {
				// "js/app.js": "js/app.js", 
				// "js/admin-app.js": "js/admin-app.js" 
			// }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["priv/static/css/app.scss"] // concat app.css last
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor", "elm"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    },
    elmBrunch: {
      elmFolder: 'elm',
      mainModules: ['Main.elm'],
      outputFolder: '../vendor'
    },
    copycat: {
      "fonts": [
        "node_modules/font-awesome/fonts",
        "node_modules/mdbootstrap/font/roboto"
      ],
      "images/svg": [
        "node_modules/mdbootstrap/img/svg"
      ]
    },
    sass: {
      options: {
        includePaths: [
          "node_modules/bootstrap/scss",
          "node_modules/font-awesome/scss",
          "node_modules/mdbootstrap/sass"
        ], // tell sass-brunch where to look for files to @import
        precision: 8 // minimum precision required by bootstrap
      }
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app.js"]
    }
  },

  npm: {
    enabled: true,
    globals: { // Bootstrap JavaScript requires both '$', 'jQuery', and Tether in global scope
      $: 'jquery',
      jQuery: 'jquery',
      Popper: 'popper.js',
      bootstrap: 'bootstrap' // require Bootstrap JavaScript globally too
    }
  }
};
