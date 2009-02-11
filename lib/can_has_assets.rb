module CanHasAssets
  module Helpers

    def can_has_js(*sources, &block)
      can_has(javascript, *sources, &block)
    end
    
    def can_has_css(*sources, &block)
      can_has(stylesheet, *sources, &block)
    end

    private

    def validate_can_has_assets(*sources, &block)
      if block_given? && sources.size > 1
        raise ArgumentError.new "Cannot create a snippet and include multiple sources at the same time."
      end
      if block_given? && sources.blank?
        raise ArgumentError.new "Must supply a key if adding a snippet"
      end
      if block_given? && sources.first.class != Symbol # accidentals
        raise ArgumentError.new "When adding a snippet, the key must be a symbol"
      end
    end
    
    def can_has(asset, *sources, &block)
      validate_can_has_assets(*sources, &block)
      if block_given?
        asset[:snippets][sources.first] = capture(&block)
      else
        asset[:sources].concat sources
      end
    end

    def javascript
      @javascripts ||= { :sources => Array.new, :snippets => {} }
    end

    def stylesheet
      @stylesheets ||= { :sources => Array.new, :snippets => {} }
    end

    def process_assets(asset, sources)
      snippets = "\r\n"
      if sources.include? :can_has_assets
        sources.insert(sources.index(:can_has_assets), *(asset[:sources].uniq))
        sources.delete(:can_has_assets)
        snippets << asset[:snippets].collect {|k, v| v }.join("\r\n")
      end
      asset[:snippets].blank? ? '' : snippets
    end

    protected

    def stylesheet_link_tag_with_can_has_css(*sources)
      snippets = process_assets(stylesheet, sources)
      unless snippets.blank?
        snippets = content_tag(:style, snippets, :type => 'text/css')        
      end
      stylesheet_link_tag_without_can_has_css(*sources) + snippets
    end

    def javascript_include_tag_with_can_has_js(*sources)
      snippets = process_assets(javascript, sources)
      unless snippets.blank?
        snippets = javascript_tag snippets
      end
      javascript_include_tag_without_can_has_js(*sources) + snippets
    end

  end
end