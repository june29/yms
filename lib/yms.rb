require "open-uri"

module YMS
  def self.cache_dir=(dir)
    @cache_dir = dir
  end

  def self.run(options)
    Runner.new(@cache_dir, options).run
  end

  class Runner
    def initialize(cache_dir, options)
      config = options[:config]

      @cache_dir = cache_dir

      @init       = options[:init]
      @name       = options[:name]
      @target     = config["target"]
      @cache_file = File.join(@cache_dir, @name)

      @notifiers = []

      if email = config["notifications"]["email"]
        @notifiers << EmailNotifier.new(email)
      end

      if twitter = config["notifications"]["twitter"]
        @notifiers << TweetNotifier.new(twitter)
      end
    end

    def run
      @init ? store : check
    end

    def store
      if File.exist? @cache_file
        $stderr.puts "Already initialized about config #{@name}"
        return
      end

      File.write(@cache_file, open(@target).read)

      puts "Initialized successfully (Cache stored in #{@cache_file})"
    end

    def check
      unless File.exist? @cache_file
        $stderr.puts "At first, please initialize."
        return
      end

      if open(@target).read == File.read(@cache_file)
        puts "No change for #{@target}"
      else
        puts "Target #{@target} is changed!"
        notify
      end
    end

    def notify
      @notifiers.each(&:notify)
    end
  end

  class EmailNotifier
    def initialize(config)
      @mail = Mail.new do
        to      config["to"]
        from    config["from"]
        subject config["subject"]
        body    config["body"]
      end

      @mail.delivery_method :smtp, config["server"].symbolize_keys
      @mail.charset = "utf-8"
    end

    def notify
      @mail.deliver!
      puts "Notified by email"
    end
  end

  class TweetNotifier
    def initialize(config)
      @status = config.delete("status")
      @client = Twitter::Client.new(config["oauth"].symbolize_keys)
    end

    def notify
      @client.update(@status)
      puts "Notified by tweet"
    end
  end
end

class Hash
  def symbolize_keys
    self.inject({}) { |tmp, (k, v)| tmp[k.to_sym] = v; tmp }
  end
end
