class Ruhoh
  module Converter
    module Markdown
      def self.extensions
        ['.md', '.markdown']
      end
      def self.convert(content)
        require 'kramdown'
        puts "hello from Kramdown"
        Kramdown::Document.new(content).to_html
      end
    end
  end
end
