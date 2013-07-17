#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  redirect '/flashback.html'
end

get '/:file.html' do
  headers 'Content-Type' => 'text/html'
  File.read "src/#{params[:file]}.html"
end

get '/:file.js' do
  headers 'Content-Type' => 'application/javascript'
  File.read "src/#{params[:file]}.js"
end

get '/:file.css' do
  headers 'Content-Type' => 'text/css'
  File.read "src/#{params[:file]}.css"
end
