require 'nokogiri'
require 'open-uri'
require 'addressable'
require_relative 'Check.rb'

# Check for broken links in all downloaded pages
#
# These are *NOT* the request failures in LogAnalyzer, which only reports failures
# for pages it actually downloads, i.e. that are in scope. This checks all <a>
# tags on a page regardless of where they lead.
class BrokenLinks < Check

    def initialize arguments
        super arguments
        @cache = {}
    end

    def check page
        html = Nokogiri::HTML page
        urls = html.xpath('//a[@href]').map { |a| a.attr :href }
        results = []

        # Ignore URLs that are not conventionally "followable" by a browser
        urls.reject! { |u| u.start_with?('tel:') || u.start_with?('mailto:') || u.start_with?('#') }

        # Construct to full URLs
        urls.map! { |u| Addressable::URI.join(@arguments.scope, u).normalize }

        urls.each do |uri|
            status = status? uri
            if status == 'read_timeout'
                results << {type: Check::WARNING, message: "Broken link: #{uri} (connection timeout)"}
            elsif status == 'socket_error'
                results << {type: Check::WARNING, message: "Broken link: #{uri} (connection error)"}
            elsif status == 'unknown'
                results << {type: Check::WARNING, message: "Broken link: #{uri} (unknown error)"}
            elsif status.to_i >= 400
                results << {type: Check::WARNING, message: "Broken link: #{uri} (HTTP #{status})"}
            end
        end
        results
    end

    private

    # Get a cached or fresh response status
    def status? uri
        downloadStatus(uri) unless @cache.include? uri
        @cache[uri]
    end

    # Download the URI to get its http response status code
    def downloadStatus uri
        options = {read_timeout: 2}
        # Add HTTP Basic Authentication if required
        if @arguments.username && @arguments.password && @arguments.scope.include?(uri.host)
            options[:http_basic_authentication] = [@arguments.username, @arguments.password]
        end

        # Get the page
        begin
            open(uri, options) { |response| @cache[uri] = response.status[0] }
        rescue OpenURI::HTTPError => error
            @cache[uri] = error.io.status[0]
        rescue Net::ReadTimeout
            @cache[uri] = 'read_timeout'
        rescue SocketError
            @cache[uri] = 'socket_error'
        rescue
            @cache[uri] = 'unknown'
        end
    end
end
