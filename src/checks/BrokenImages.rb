require 'nokogiri'
require 'open-uri'
require 'addressable'
require_relative 'Check.rb'
require_relative 'URLTester.rb'

# Check that all image tags on the page return a valid response code
class BrokenImages < Check

    def initialize arguments
        super arguments
        @slow = true
        @tester = URLTester.new arguments.username, arguments.password
    end

    def check page
        html = Nokogiri::HTML page
        results = []

        urls = html.xpath('//img').map { |a| a.attr :src }

        urls.reject{|u| !u.nil? }.each do |url|
            $d.debug "testing for broken image: got <img> without src attribute"
            results << {type: Check::WARNING, message: "Broken image: tag has no src attribute"}
        end
        urls.reject! {|u| u.nil?}
        urls.map! { |u| Addressable::URI.join(@arguments.scope, u).normalize }

        urls.each do |uri|
            status = @tester.status? uri
            $d.debug "testing for broken image: #{uri} -> #{status}"

            if ['read_timeout', 'socket_error'].include? status
                results << {type: Check::ERROR, message: "Broken image: #{uri} (connection error)"}
            elsif status == 'unknown'
                results << {type: Check::ERROR, message: "Broken image: #{uri} (unknown error)"}
            elsif status.to_i >= 400
                results << {type: Check::ERROR, message: "Broken image: #{uri} (HTTP #{status})"}
            end
        end
        results
    end
end
