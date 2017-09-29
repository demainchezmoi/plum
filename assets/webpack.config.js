var CopyWebpackPlugin = require('copy-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var path = require('path');
var webpack = require('webpack');

config = {
  entry: {
    app: './js/app.js',
    admin: './js/admin.js',
    prospect: './js/prospect.js'
  },
  output: {
    path: path.join(__dirname, '..', 'priv', 'static'),
    filename: 'js/[name].js'
  },
  module: {
    rules: [{
      test: /.*elm-admin.*\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: {
        loader: 'elm-webpack-loader',
        options: {
          cwd: 'elm-admin'
        }
      }
    }, {
      test: /.*elm-prospect.*\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: {
        loader: 'elm-webpack-loader',
        options: {
          cwd: 'elm-prospect'
        }
      }
    }, {
      // test: /\.png$|\.jpg$/,
      // loader: 'url-loader',
      // }, {
      test: /\.js$/,
      exclude: /(node_modules)/,
      loader: 'babel-loader',
      query: {
        presets: ['env']
      }
    }, {
      test: /\.scss$/,
      exclude: [/node_modules/],
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: [
          'css-loader?sourceMap',
          {
            loader: 'sass-loader?sourceMap',
            options: {
              includePaths: [
                path.resolve(__dirname, 'node_modules/bootstrap/scss'),
                path.resolve(__dirname, 'node_modules/font-awesome/scss'),
                path.resolve(__dirname, 'node_modules/mdbootstrap/sass')
              ]
            }
          }
        ]
      })
    }, {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        use: 'css-loader?sourceMap'
      })
    }, {
      test: /\.woff($|\?)|\.woff2($|\?)|\.ttf($|\?)|\.eot($|\?)|\.svg($|\?)/,
      loader: 'url-loader'
    }]
  },
  resolve: {
    modules: [
      'node_modules',
      path.join(__dirname, 'js'),
    ]
  },
  plugins: [
    new ExtractTextPlugin({filename: 'css/app.css'}),
    new CopyWebpackPlugin([{from: './static'}, {from: './node_modules/mdbootstrap/font/roboto', to: 'fonts'}]),
    new webpack.ProvidePlugin({
      '$': 'jquery',
      'jQuery': 'jquery',
      'window.jQuery': 'jquery',
			'Tether': 'tether',
			'Popper': ['popper.js', 'default'],
			'Waves': 'node-waves'
		})
  ]
};

if (process.env.ENV === 'production') {
  config.plugins = config.plugins.concat([
    new webpack.optimize.UglifyJsPlugin({
      output: {
        comments: false
      },
    })
  ]);
}

module.exports = config;
