require 'rest-client'
require 'nokogiri'
require 'launchy'
require 'addressable/uri'



class HNClient

  attr_accessor :homepage_html

  def initialize
    @homepage_html = get_home_page
    @zipped = zip(@homepage_html)
  end

  # def run_loop
  #   while true
  #     show_headlines
  #     puts "here are the headlines. choose one you'd like to investigate"
  #     # comments = get_comment_links(@homepage_html)
  #     choice = gets.chomp.to_i
  #     puts "Do you want to view the (p)age, or the (c)omments?"
  #     command = gets.chomp
  #     case command
  #     when "p"
  #       links = get_homepage_links(@homepage_html)
  #       Launchy.open(links[choice - 1])
  #     when "c"
  #       comment_links = comment_page_links(@homepage_html)
  #       Launchy.open(create_query(comment_links[choice - 1], nil))
  #     end
  #   end
  # end

  # Homepage Interactions

    def get_home_page
      Nokogiri::HTML(RestClient.get 'http://news.ycombinator.com')
    end

    def get_headlines(homepage_html)
      a_tags = homepage_html.css('tr td.title a')
      headlines = get_text(a_tags)
    end

    def get_homepage_links(homepage_html)
      a_tags = homepage_html.css('tr td.title a')
      links = get_links(a_tags)
    end

    # Takes us to the comment page
    def get_comments_counts(homepage_html)
      comment_counts = homepage_html.css('tr td.subtext a:nth-of-type(2)')
      comment_counts = get_text(comment_counts)
    end

    def comment_page_links(homepage_html)
      comments = homepage_html.css('tr td.subtext a:nth-of-type(2)')
      comment_links = []
      comments.each do |link|
        comment_links << link['href']
      end
      comment_links
    end

  # Display stuff

  def show_headlines
    headlines = get_headlines(@homepage_html)
    headlines.each_with_index do |headline, index|
      puts "#{index + 1} | #{headline}"
    end
    nil
  end

  # Individual Story Constructor

  # def story_builder(index)
  #   headline
  #   link
  #   comment_link
  #   comment_counts
  #   story_id

  # end

  def zip(homepage_html)
    zip = get_headlines(homepage_html).zip(get_homepage_links(homepage_html), get_comments_counts(homepage_html), comment_page_links(homepage_html))
  end

  def story_builder
    story_array = []
    build_array = zip(@homepage_html)
    build_array.each do |story|
      headline, link, comment_count, comment_link = story
        story_array << Story.new(headline, link, comment_link, comment_count)
    end
    story_array
  end

  # Helper Methods

  def get_text(cut_down_html)
    text = []
    cut_down_html.each do |content|
      text << content.text
    end
    text
  end

  def get_links(cut_down_html)
    text = []
    cut_down_html.each do |content|
      text << content['href']
    end
    text
  end

  def create_query(path, query)
    Addressable::URI.new(
     :scheme => "http",
     :host => "news.ycombinator.com",
     :path => path,
     :query_values => {:id => query}
   ).to_s
  end


  # Individual User Stuff

    def get_posts_from_user(username)
      user_submissions_page = Nokogiri::HTML(RestClient.get create_query('submitted', username))
      a_tags = user_submissions_page.css('tr td.title a')
      headlines = get_text(a_tags)

    end

    def get_comments_from_user(username)
      # user_comments_page = Nokogiri::HTML(RestClient.get create_query('threads', username))
      # a_tags = user_comments_page.css('td.default')

      Launchy.open (create_query('threads', username))
    end



end


class Story

  attr_accessor :headline, :story_link, :comment_link, :comment_count
  def initialize(headline, story_link, comment_link, comment_count)
    @headline = headline
    # @user
    @story_link = story_link
    @comment_link = comment_link
    @comment_count = comment_count
  end

  def link

  end

  def uder_name
  end

  def points
  end

  def comments
  end

end


class User

end


class Comment

end
