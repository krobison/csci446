#!/usr/bin/ruby

require 'ERB'
require 'sqlite3'
require 'sinatra'
require 'data_mapper'
require_relative 'book'

get '/form' do
	erb :form
end

get '/list' do
	erb :list
end