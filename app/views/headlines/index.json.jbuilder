json.array!(@headlines) do |headline|
  json.id headline.id
  json.title headline.title
  json.created_at show_datetime(headline.created_at)
end
