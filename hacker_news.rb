require 'rest-client'
require 'nokogiri'
require 'launchy'




class HNClient

  attr_accessor :headlines, :links, :comment_count, :comment_links

  def initialize
    homepage_html = get_home_page
    @headlines = get_headlines(homepage_html)
    @links = get_links(homepage_html)
    @comment_count = get_comments(homepage_html)
    @comment_links = show_comments(homepage_html)
    @user_submissions = get_posts_from_user('thibaut_barrere')
  end

  def get_home_page
    Nokogiri::HTML(RestClient.get 'http://news.ycombinator.com')
  end

  def get_headlines(homepage_html)
    a_tags = homepage_html.css('tr td.title a')
    headlines = []
    a_tags.each do |link|
      headlines << link.text
    end
    headlines
  end

  def get_links(homepage_html)
    a_tags = homepage_html.css('tr td.title a')
    links = []
    a_tags.each do |link|
      links << link['href']
    end
    links
  end

  def get_comments(homepage_html)
    comment_counts = homepage_html.css('tr td.subtext a:nth-of-type(2)')
    comments = []
    comment_counts.each do |comment|
      comments << comment.text
    end
    comments
  end

  def show_comments(homepage_html)
    comments = homepage_html.css('tr td.subtext a:nth-of-type(2)')
    comment_links = []
    comments.each do |link|
      comment_links << link['href']
    end
    comment_links
  end

  def get_posts_from_user(username)
    user_submissions_page = Nokogiri::HTML(RestClient.get 'http://news.ycombinator.com/submitted?id=#{username}')
    a_tags = user_submissions_page.css('tr td.title a')
    headlines = []
    a_tags.each do |link|
      headlines << link.text
    end
    headlines
  end

  def get_comments_from_user(username)

  end

end
