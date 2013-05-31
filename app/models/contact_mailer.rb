class ContactMailer < ActionMailer::Base

  def confirmation(contact, sent_at = Time.now)
    subject    "Kontakt über #{SITE_URL}"
    recipients contact.email
    from       "noreply@#{SITE_URL}"
    sent_on    sent_at
    
    body       :contact => contact
  end

  def message(contact, sent_at = Time.now)
    subject    "Kontakt über #{SITE_URL}"
    recipients "webmaster@#{SITE_URL}"
    from       contact.email
    sent_on    sent_at
                                 
    body       :contact => contact
  end

  # blackboard postings
  def notify(post, sent_at = Time.now)
    subject    "Neuer Eintrag auf #{SITE_URL}"
    recipients "webmaster@#{SITE_URL}"
    from       post.email
    sent_on    sent_at

    body       :post => post
  end

  # moderated comments
  def checkit(comment, sent_at = Time.now)
    subject    "Neuer Kommentar auf #{SITE_URL}"
    recipients "webmaster@#{SITE_URL}"
    from       "www@#{SITE_URL}"
    sent_on    sent_at

    body       :comment => comment, :place => comment.place
  end

end
