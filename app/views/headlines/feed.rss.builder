xml.instruct! :xml, version: '1.0'
xml.rss 'version' => '2.0',
    'xmlns:content' => 'http://purl.org/rss/1.0/modules/content/',
    'xmlns:wfw' => 'http://wellformedweb.org/CommentAPI/' do
  xml.channel do
    xml.title 'お知らせ - RECMATCH'
    xml.description 'RECMATCHからのお知らせ'
    xml.link root_url

    @headlines.each do |headline|
      xml.item do
        xml.title headline.title
        xml.tag! 'content:encoded' do
          xml.cdata! simple_format(headline.body.html_safe)
        end

        xml.pubDate headline.published_at.to_s(:rfc822)
        xml.link headline_url(headline)
        xml.guid headline_url(headline)
      end
    end
  end
end
