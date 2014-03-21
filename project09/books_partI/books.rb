#!/usr/bin/ruby

require 'rack'
require 'ERB'
require 'sqlite3'

class BookApp
	def initialize()
	end

	def call(env)
		# create request and response objects
		request = Rack::Request.new(env)
		response = Rack::Response.new
		# include the header
		File.open("books.html", "r") { |head| response.write(head.read) }
		case env["PATH_INFO"]
			when /.*?\.css/
				# serve up a css file
				# remove leading /
				file = env["PATH_INFO"][1..-1]
				return [200, {"Content-Type" => "text/css"}, [File.open(file, "rb").read]]
			when /\/list.*/
				# serve up the form
				render_list(request, response)
			when /\/form.*/
				# serve up a list response
				render_form(request, response)
			#404 error page not found
			else
				[404, {"Content-Type" => "text/plain"}, ["Error 404!"]]
			end

		response.finish
	end
		
	def render_list(req, response)
		response.write(ERB.new(File.read("list.erb")).result(binding))
		response.write(footer)
	end
	
	def render_form(req, response)
		response.write(ERB.new(File.read("form.erb")).result(binding))
		response.write(footer)
	end
	
	def footer
		"<footer><br><br>&copy; 2014 Kolten Robison </footer>"
	end
end


Signal.trap('INT') {
	Rack::Handler::WEBrick.shutdown
}

Rack::Handler::WEBrick.run BookApp.new, :Port => 8080
