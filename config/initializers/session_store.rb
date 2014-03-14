# Be sure to restart your server when you modify this file.

#Cloudweb::Application.config.session_store :cookie_store, key: '_cloudweb_session'
Cloudweb::Application.config.session_store :active_record_store
ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id
#Foo::Application.config.session_store :active_record_store