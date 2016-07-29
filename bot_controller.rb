require 'twitter'

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

  end
  
  def process
  
    ## @EveryDemDonor
    popular_tweet_ids = popular_tweets( "EveryDemDonor" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause

    ## @EveryGOPDonor
    popular_tweet_ids = popular_tweets( "EveryGOPDonor" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause

    ## @EveryTrumpDonor
    popular_tweet_ids = popular_tweets( "EveryTrumpDonor" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @TheSeinfeldBot
    popular_tweet_ids = popular_tweets( "TheSeinfeldBot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @TrendingHx
    popular_tweet_ids = popular_tweets( "TrendingHx" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause

    ## @TeaPartyBot
    popular_tweet_ids = popular_tweets( "TeaPartyBot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @Bernie_ebooks
    popular_tweet_ids = popular_tweets( "Bernie_ebooks" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @ConfederateBot
    popular_tweet_ids = popular_tweets( "ConfederateBot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @colombia_bot
    popular_tweet_ids = popular_tweets( "colombia_bot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @BillyJoel_Bot
    popular_tweet_ids = popular_tweets( "BillyJoel_Bot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?

    ## @RepElizaTuring
    popular_tweet_ids = popular_tweets( "RepElizaTuring" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?

    ## @RepHalTuring
    popular_tweet_ids = popular_tweets( "RepHalTuring" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    
  end
  
  def popular_tweets( twitter_handle, threshold=3 )
    tweet_ids = []
    tweets = @client.search("from:#{twitter_handle} exclude:retweets", result_type: "recent").take(50)
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
  
  def pause
    sleep( rand(10)+5 )
  end

end