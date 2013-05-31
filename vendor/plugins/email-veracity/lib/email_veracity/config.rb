module EmailVeracity


  class Config

    DEFAULT_OPTIONS = {
      :whitelist => %w[ devnull.expoeasy.de web.de gmx.de aol.com gmail.com hotmail.com mac.com msn.com
        yahoo.com telus.com sprint.com sprint.ca ],
      :blacklist => %w[ dodgeit.com mintemail.com mintemail.uni.cc
        1mintemail.mooo.com spammotel.com trashmail.net ],
      :valid_pattern =>
        /\A(([\w]+[\w\+_\-\.]+[\+_\-\.]{0})@((?:[-a-z0-9]+\.)+[a-z]{2,})){1}\Z/i,
      :timeout => 3,
      :lookup => [:a],
      :enforce_blacklist => false,
      :enforce_whitelist => true }
    @options = DEFAULT_OPTIONS.clone

    def Config.[](key)
      @options[key.to_sym]
    end

    def Config.[]=(key, value)
      @options[key.to_sym] = value
    end

    def Config.options
      @options
    end

    def Config.options=(options)
      unless options.is_a?(Hash)
        raise ArgumentError, "options must be a Hash not #{options.class}"
      end
      @options = options
    end

    def Config.update(options)
      unless options.is_a?(Hash)
        raise ArgumentError, "options must be a Hash not #{options.class}"
      end
      @options.update(options)
    end

    def Config.enforce_lookup?(record)
      return unless @options[:lookup].is_a?(Array)
      @options[:lookup].any? { |i| i.to_s == record.to_s }
    end

    def Config.revert!
      @options = DEFAULT_OPTIONS.clone
    end

  end


end