require 'nokogiri'
require 'uri'
require 'net/http'
require_relative 'Check.rb'

class BrokenLinks < Check

    def initialize scope
        @scope = scope
        @cache = {}
    end

    def check page
        html = Nokogiri::HTML page
        urls = html.xpath('//a[@href]').map { |a| a.attr :href }
        results = []

        # Ignore URLs that are not conventionally "followable" by a browser
        urls.reject! { |u| u.start_with?('tel:') || u.start_with?('mailto:') || u.start_with?('#') }

        # Construct to full URLs
        urls.map! { |u| URI.join @scope, u }

        urls.each do |uri|
            status = status? uri
            results << {type: Check::WARNING, message: "Broken link: #{uri} (HTTP #{status})"} if status < 200 || status >= 400
        end
        results
    end

    private 

    def status? uri
        return @cache[uri] if @cache.include? uri

        http = Net::HTTP.new uri.host, uri.port
        http.use_ssl = (uri.scheme == "https")
        http.start do |http|
            status = http.request(Net::HTTP::Head.new(uri)).code.to_i
            @cache[uri] = status
            return status
        end
    end
end
