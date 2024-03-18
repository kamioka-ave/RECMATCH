class AdminBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    @context.render "/layouts/admin_breadcrumbs", elements: @elements
  end
end
