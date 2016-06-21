require 'twitter'
#require_relative 'bot_brain'

class BotController
  
  def initialize
    ## Bot user
    @user_screen_name = "AdamsBots"
    @user_id = 726236859655815169
    ## App config settings
    config = {
      consumer_key:        ENV['ADAMS_BOTS_CONSUMER_KEY'],
      consumer_secret:     ENV['ADAMS_BOTS_CONSUMER_SECRET'],
      access_token:        ENV['ADAMS_BOTS_ACCESS_TOKEN'],
      access_token_secret: ENV['ADAMS_BOTS_ACCESS_TOKEN_SECRET']
    }

    ## Get client
    @client = Twitter::REST::Client.new( config )
    ## Setup bots
    #@bots = setup_bots
  end
  
  def process
=begin    
    tweet_ids = []
    threshold = 2
    
    ## @EveryDemDonor
    tweets = @client.search("from:EveryDemDonor exclude:retweets", result_type: "recent").take(100)
    tweets.each do |tweet|
      count = tweet.favorite_count + tweet.retweet_count
      if count >= threshold
        results = @client.retweets( tweet.id )
        previously_retweeted = false
        results.each do |result|
          previously_retweeted = true if result.user.id == @user_id
        end
        tweet_ids << tweet.id unless previously_retweeted
      end
    end

    @client.retweet( tweet_ids.first ) if tweet_ids.any?
=end
    #if count > threshold
    #  @client.retweet(tweet.id)
    #end
    #results=client.retweets tweet.id
    
    ## @EveryDemDonor
    #popular_tweet_ids = popular_tweets( "EveryDemDonor" )
    #@client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?

    ## @EveryGOPDonor
    #popular_tweet_ids = popular_tweets( "EveryGOPDonor" )
    #@client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?

    ## @EveryTrumpDonor
    #popular_tweet_ids = popular_tweets( "EveryTrumpDonor" )
    #@client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    
    ## @TheSeinfeldBot
    popular_tweet_ids = popular_tweets( "TheSeinfeldBot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    
  end
  
  def popular_tweets( twitter_handle, threshold=2 )
    tweet_ids = []
    tweets = @client.search("from:#{twitter_handle} exclude:retweets", result_type: "recent").take(100)
    tweets.each do |tweet|
      count = tweet.favorite_count + tweet.retweet_count
      if count >= threshold
        results = @client.retweets( tweet.id )
        previously_retweeted = false
        results.each do |result|
          previously_retweeted = true if result.user.id == @user_id
        end
        tweet_ids << tweet.id unless previously_retweeted
      end
    end
    tweet_ids
  end
  
  def tweet
    bot = @bots.first
    tweet = generate_tweet( bot )
    if tweet
      @client.update( tweet )
      puts tweet
    else
      puts "NO RESULTS"
    end
  end
  
  def test
    bot = @bots.first
    tweet = generate_tweet( bot )
    if tweet
      puts tweet
    else
      puts "NO RESULTS"
    end
  end
    
  def generate_tweet( bot )
    ## Twitter location id
    usa = "23424977"
    ## Get trends
    trends = @client.trends( id=usa )
    ## Find valid trend
    results = []
    valid_trend = nil
    trends.each do |trend|
      ## Ignore promoted content
      next if trend.promoted_content?
      valid_trend = trend
      puts trend.name
      ## Get user timeline
      tweets = @client.user_timeline
      tweets.each do |tweet|
        if tweet.text.downcase.match( trend.name.gsub(' ','').downcase )
          valid_trend = nil
          break
        end
      end
      results = bot.process( valid_trend.name ) if valid_trend
      break if results.any?
    end
    if results.any?
      return results.shuffle.first.tweet.last
    end
    nil
  end
  
  def duplicate?( result )
    search_str = "from:#{@user_screen_name} #{result}"
    results = @client.search( search_str )
    results.any? ? true : false
  end 
  
  def list( name )
    bot = @bots.first
    results = bot.process( name )
    if results.any?
      results.each { |r| puts r.tweet.last }
    else
      puts "NO RESULTS"
    end
  end
  
  private
  
  def setup_bots
    bots = []
    bots << BotBrain.new()
    bots
  end

end