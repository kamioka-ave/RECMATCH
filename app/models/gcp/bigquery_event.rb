class BigqueryEvent < Bigquery
  def create_table
    table = @dataset.table('events', skip_lookup: true)
    if table.exists?
      table
    else
      @dataset.create_table 'events', name: 'イベント', description: 'イベントテーブル' do |t|
        t.schema do |s|
          s.integer 'id', mode: :required, description: 'イベントID'
          s.integer 'visit_id', mode: :required, description: '訪問ID'
          s.integer 'user_id', mode: :nullable, description: 'ユーザーID'
          s.string 'name', mode: :required, description: 'イベント名'
          s.string 'properties', mode: :required, description: 'プロパティ'
          s.timestamp 'time', mode: :required, description: '日時'
        end
      end
    end
  end

  def sync
    super do |file|
      Ahoy::Event.all.each do |e|
        file.puts(e.as_bigquery_json.to_json)
      end
    end
  end

  def insert(event)
    @table.insert(event.as_bigquery_json)
  end
end