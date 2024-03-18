module Projectable
  extend ActiveSupport::Concern

  ANGEL_TYPE_NONE = 0
  ANGEL_TYPE_A = 1
  ANGEL_TYPE_B = 2

  CONTRACT_BEFORE_TYPE_PDF = 0
  CONTRACT_BEFORE_TYPE_HTML = 1

  included do
    def self.names_with_angel_type
      {
        対応なし: ANGEL_TYPE_NONE,
        タイプA: ANGEL_TYPE_A,
        タイプB: ANGEL_TYPE_B
      }
    end

    def self.names_with_contract_before_type
      {
        PDF: CONTRACT_BEFORE_TYPE_PDF,
        HTML: CONTRACT_BEFORE_TYPE_HTML
      }
    end

    def as_json(options = {})
      super(options).merge(
        contract_before_type: self.class.names_with_contract_before_type.key(contract_before_type),
        contract_before_url: contract_before.present? ? contract_before.url : nil,
        law_notification: law_notification.present? ? law_notification.url : nil,
        image_url: image.present? ? image.url : nil,
        image_thumb_url: image.present? ? image.thumb.url : nil,
        president_image_url: president_image.present? ? president_image.url : nil,
        president_image_thumb_url: president_image.present? ? president_image.thumb.url : nil,
        stamp_url: stamp.present? ? stamp.url : nil,
        stamp_thumb_url: stamp.present? ? stamp.thumb.url : nil,
        status: self.class.names_with_status.key(status),
        admin: admin.present? ? admin.name : nil,
        authorizer: authorizer.present? ? authorizer.name : nil,
        category_ids: categories.map(&:id),
        contract_images: contract_images,
        company_presidents: company_presidents,
        contract_attachment_url: contract_attachment.present? ? contract_attachment.url : nil
      )
    end
  end
end
