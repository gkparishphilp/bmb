# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The todo Blog"
    xml.description "A blog about todo."
    xml.link author_blog_index_url( @author, :format => :rss ) 
    
    for article in @articles
      xml.item do
        xml.title article.title
        xml.description article.content
        xml.pubDate article.created_at.to_s( :rfc822 )
        xml.link blog_url( article )
        xml.guid author_blog_url( @author, article, :format => :rss )
      end
    end
  end
end