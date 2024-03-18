module DocumentsHelper
  def document_time(identifier)
    Time.at(identifier.split('-').first.to_i)
  end
end
