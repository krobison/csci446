#!/usr/bin/ruby

require 'rack'


class Book
	#The constructor accepts several information parameters
	def initialize(title,author,language,year,copies,rank)
		@title = title
		@author = author
		@language = language
		@year = year
		@copies = copies
		@rank = rank
	end
	
	def title
		@title
	end
	
	def author
		@author
	end
	
	def language
		@language
	end
	
	def year
		@year
	end
	
	def copies
		@copies
	end
	
	def rank
		@rank
	end
end

class BookApp
	def initialize()
		@booksFile = "books.txt"
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
		loadBooks
		
		sorter = req.GET["sorter"]
		
		if sorter == "author"
			@books.sort! { |a,b| a.author <=> b.author }
		elsif sorter == "copies"
			@books.sort! { |a,b| a.rank <=> b.rank }
		elsif sorter == "language"
			@books.sort! { |a,b| a.language <=> b.language }
		elsif sorter == "rank"
			@books.sort! { |a,b| a.rank <=> b.rank }
		elsif sorter == "title"
			@books.sort! { |a,b| a.title <=> b.title }
		elsif sorter == "year"
			@books.sort! { |a,b| a.year <=> b.year }
		end
		
		response.write("<table><tr><th>Rank</th><th>Title</th><th>Author</th><th>Language</th><th>Year</th><th>Copies</th></tr>")
		@books.each do |book|
			response.write("<tr>")
			response.write("<td>#{book.rank}</td>")
			response.write("<td>#{book.title}</td>")
			response.write("<td>#{book.author}</td>")
			response.write("<td>#{book.language}</td>")
			response.write("<td>#{book.year}</td>")
			response.write("<td>#{book.copies}</td>")
			response.write("</tr>")
		end
		response.write("</table>")
		response.write(footer)
	end
	
	def render_form(req, response)
		response.write("<form action=\"list\">")
		response.write("<select name=\"sorter\">")
		response.write("<option value=\"author\">Author</option>")
		response.write("<option value=\"copies\">Copies</option>")
		response.write("<option value=\"language\">Language</option>")
		response.write("<option value=\"rank\">Rank</option>")
		response.write("<option value=\"title\">Title</option>")
		response.write("<option value=\"year\">Year</option>")
		response.write("</select>")
		response.write("<button type=\"submit\">Show books</button>")
		response.write("</form>")
		response.write(footer)
	end
	
	#load the books in from the .txt file
	def loadBooks()
		file = File.open(@booksFile, 'r')
		@lines = []
		while !file.eof?
			@lines << file.readline
		end
		@books = []
		rank = 1
		@lines.each do |line|
			params = line.split(',')
			@books << Book.new(params[0],params[1],params[2],params[3],params[4],rank)
			rank += 1
		end
	end
	
	def footer
		"<footer><br><br>&copy; 2014 Kolten Robison </footer>"
	end
end


Signal.trap('INT') {
	Rack::Handler::WEBrick.shutdown
}

Rack::Handler::WEBrick.run BookApp.new, :Port => 8080
