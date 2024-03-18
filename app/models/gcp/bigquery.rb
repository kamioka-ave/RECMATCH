require 'google/cloud/bigquery'

class Bigquery
  def initialize
    @bigquery = Google::Cloud::Bigquery.new(
      project: ENV['RECMATCH_BIGQUERY_PROJECT'],
      keyfile: ENV['RECMATCH_GOOGLE_APPLICATION_CREDENTIALS']
    )

    @dataset = @bigquery.dataset('fundinno', skip_lookup: true)
    unless @dataset.exists?
      @dataset = @bigquery.create_dataset('fundinno')
    end

    @table = create_table
  end

  def create_table
    raise 'You must implement this method in your class.'
  end

  def sync
    file_name = "#{self.class.name}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.json"

    tmp = Rails.root.join('tmp/bigquery')
    unless Dir.exist?(tmp)
      Dir.mkdir(tmp)
    end

    file_path = File.join(tmp, file_name)
    file = File.open(file_path, 'w+')
    yield file
    file.close

    if @table.exists?
      @table.delete
      @table = create_table
    end

    file = File.open(file_path, 'r')
    @table.load(file, format: :json)
    file.close

    File.delete(file_path)
  end
end