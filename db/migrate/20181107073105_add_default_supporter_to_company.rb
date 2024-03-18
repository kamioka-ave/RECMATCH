class AddDefaultSupporterToCompany < ActiveRecord::Migration[5.2]
  def change
    supporter_ids = [2, 3, 4, 5, 6, 7, 8]
    ActiveRecord::Base.transaction do
      Company.where(chat_toggle: [nil, false]).each do |company|
        GroupChat::Category.display.each do |category|
          group_chat = company.group_chats.find_or_create_by!(category: category)
          supporter_ids.each do |id|
            supporter = Supporter.find_by id: id
            next unless supporter
            Consultation.find_or_create_by!(company: company, supporter: supporter, group_chat_category: category)
          end
        end
        company.consultations.where.not(supporter_id: supporter_ids).destroy_all
      end
    end
    puts "Add Default Supporter To Company Success!"
  end
end
