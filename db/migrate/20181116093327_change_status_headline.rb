class ChangeStatusHeadline < ActiveRecord::Migration[5.2]
  def up
    Headline.all.each do |headline|
      headline.update_column(:status, Headline::S_PUBLISHED)
    end
  end
end
