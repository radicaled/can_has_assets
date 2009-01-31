require 'can_has_assets'

ActionView::Base.send :include, CanHasAssets::Helpers
ActionView::Base.send :alias_method_chain, :stylesheet_link_tag, :can_has_css
ActionView::Base.send :alias_method_chain, :javascript_include_tag, :can_has_js