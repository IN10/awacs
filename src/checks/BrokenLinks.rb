require 'nokogiri'
require_relative 'Check.rb'

class BrokenLinks < Check

    def check page
        html = Nokogiri::HTML page
        urls = html.xpath('//a[@href]').map { |a| a.attr :href }
        urls.reject! do |url|
            url.start_with?('tel:') || url.start_with?('mailto:') || url.start_with?('#')
        end

        puts urls.inspect
        exit 13

        # if page.include? 'warning'
        #     results << {type: Check::WARNING, message: "Page contains 'warning'"}
        # end

        # ['error', 'Exception'].each do |oracle|
        #     if page.include? oracle
        #         results << {type: Check::ERROR, message: "Page contains an error keyword"}
        #     end
        # end

        results
    end
end
