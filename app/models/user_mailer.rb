class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Bitte aktivieren Sie Ihren Zugang'
  
    @body[:url]  = "https://#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Ihr Zugang wurde aktiviert'
    @body[:url]  = "https://#{SITE_URL}/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "support"
      @subject     = "[#{SITE_URL}] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
