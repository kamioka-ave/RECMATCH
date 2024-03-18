xml.instruct! :xml, version: '1.0'
xml.rss 'version' => '2.0',
    'xmlns:content' => 'http://purl.org/rss/1.0/modules/content/',
    'xmlns:wfw' => 'http://wellformedweb.org/CommentAPI/' do
  xml.channel do
    xml.title '新着企業 - RECMATCH'
    xml.description 'RECMATCHの新着企業'
    xml.link root_url

    @projects.each do |project|
      xml.item do
        xml.title project.name
        xml.description strip_tags(project.short_description)
        xml.tag! 'content:encoded' do
          xml.cdata! simple_format(project.description.html_safe)
        end

        xml.pubDate project.updated_at.to_s(:rfc822)
        xml.link project_url(project)
        xml.guid project_url(project)
      end
    end
  end
end
