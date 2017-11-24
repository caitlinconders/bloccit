module ApplicationHelper
  # The & turns the block into a Proc, which we've seen before but haven't named. A Proc is a block that can be reused like a variable.
  def form_group_tag(errors, &block)
  css_class = 'form-group'
  css_class << ' has-error' if errors.any?
  # the content_tag helper method is called. This method is used to build the HTML and CSS to display the form element and any associated errors.
  content_tag :div, capture(&block), class: css_class
end
end
