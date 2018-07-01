const path = require('path')

const CopyWebpackPlugin = require('copy-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const env = process.env.MIX_ENV || 'dev'
const isProduction = (env === 'prod')
const mode = env === 'prod' ? 'production' : 'development'

module.exports = {
  devtool: 'source-map',
  entry: ['./js/app.js', './css/app.scss'],
  mode: mode,
  module: {
    rules: [
      {
        test: /\.scss$/,
        include: /css/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            {
              loader: 'css-loader',
              options: {
                minimize: true,
                sourceMap: !isProduction
              }
            },
            {
              loader: 'sass-loader',
              options: {
                includePaths: [
                  path.resolve(__dirname, 'node_modules')
                ],
                outputStyle: 'compressed',
                sourceMap: !isProduction
              }
            }
          ]
        })
      },
      {
        test: /\.tsx?$/,
        use: [
          {loader: 'ts-loader'}
        ]
      }
    ]
  },
  output: {
    path: path.resolve(__dirname, '../priv/static'),
    filename: 'js/app.js'
  },
  plugins: [
    new CopyWebpackPlugin([{from: './static'}]),
    new ExtractTextPlugin('css/app.css')
  ],
  resolve: {
    extensions: [
      '.js',
      '.jsx',
      '.ts',
      '.tsx'
    ],
    modules: [
      'node_modules',
      path.resolve(__dirname, './js')
    ]
  }
}
