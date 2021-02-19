# Be sure to restart your server when you modify this file.

 ActiveSupport::Reloader.to_prepare do
   ApplicationController.renderer.defaults.merge!(
     http_host: '192.168.30.33:3000',
     https: false
   )
 end
