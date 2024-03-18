class Site < ApplicationRecord
  belongs_to :project

  with_options on: :featured_project do |f|
    f.validates :project_id, presence: true
  end

  def refresh_props!
    execution_price = Project.where.not(execution_price: nil)
                        .map { |project| project.deliv_price.nil? ? project.execution_price : project.deliv_price }
                        .reduce(0) { |sum, price| sum + price }
    projects = Project.where(is_succeeded_with_limit: true)

    if Rails.env.production?
      projects = projects.where('id >= ?', 1)
    end

    fastest_project = projects.sort { |a, b| (b.succeeded_at - b.start_at) <=> (a.succeeded_at - a.start_at) }.last

    fastest_second = nil
    ordered_amount = 0
    Order.where(project_id: fastest_project&.id).each do |order|
      if order.type == 'NormalOrder'
        ordered_amount += order.price
      elsif order.type == 'CancelOrder'
        ordered_amount -= order.price
      end

      if ordered_amount == fastest_project.solicit_limit
        fastest_second = order.order_at.to_i - fastest_project.start_at.to_i
        break
      end
    end

    update!(
      execution_price: execution_price,
      fastest_second: fastest_second,
      fastest_price: fastest_project&.solicited
    )
  end
end
