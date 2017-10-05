
module Cheatsheet
  class Client

    SOURCE = "https://raw.githubusercontent.com/rstacruz/cheatsheets/gh-pages/"
    FILES_SOURCE = "https://api.github.com/repos/rstacruz/cheatsheets/contents/"

    def self.fetch(*args)
      key = args[0].first

      # Show available cheatsheets
      if (key === '-a')
	files_uri = URI(FILES_SOURCE)
	begin
	  files = JSON.parse(self.fetch_raw(files_uri))
	  filter = ''

	  if args[0].size > 1
	    filter = args[0].last
	  end
	  
          mds = files.select { |elem|
            elem['name'].end_with?(".md") && elem['name'].include?(filter)
          }.map { |elem|
	    elem['name'][0..-4]
	  }

	  puts mds
	rescue CheatSheetClientException => e
          puts e.message
        end
      else
        uri = URI(SOURCE + key + ".md")
        begin
          puts self.fetch_raw(uri)
        rescue CheatSheetClientException => e
          puts e.message
        end
      end
    end

    def self.fetch_raw(uri)
      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess then
        Net::HTTP.get(uri)
      when Net::HTTPNotFound then
        raise CheatSheetClientException.new "We don't have that cheatsheet yet. Feel free to contribute here: https://github.com/rstacruz/cheatsheets"
      else
        response.value
      end
    end

  end
end

class CheatSheetClientException < Exception
end
