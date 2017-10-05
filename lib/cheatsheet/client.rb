
module Cheatsheet
  class Client

    SOURCE = "https://raw.githubusercontent.com/rstacruz/cheatsheets/gh-pages/"
    FILES_SOURCE = "https://api.github.com/repos/rstacruz/cheatsheets/contents/"

    def self.start(*args)
        begin
          self.render(self.fetch(*args))
        rescue CheatSheetClientException => e
          self.render e
        end
    end

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
            File.basename(elem['name'],File.extname(elem['name']))
          }

          if mds.size === 0
            raise CheatSheetClientException.new "We don't have any cheatsheet matching your search query"
          end

          return mds
        rescue CheatSheetClientException => e
          raise CheatSheetClientException.new e.message
        rescue JSON::ParserError
          raise CheatSheetClientException.new "Try again later"
        end
      else
        uri = URI(SOURCE + key + ".md")
        begin
          return self.fetch_raw(uri)
        rescue CheatSheetClientException => e
          raise CheatSheetClientException.new e.message
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

    def self.render(string)
      puts string
    end

  end
end

class CheatSheetClientException < Exception
end
