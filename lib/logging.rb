# (c) 2007, 2008 Transformal GmbH, Berlin.
# Diese Software ist für die Transformal GmbH urheberrechtlich geschützt.
# Ihre Änderung, Weitergabe oder Benutzung ist nur nach vorheriger schriftlicher
# Zustimmung der Transformal GmbH erlaubt.

module Logging
  
  # Enhances the controller with logging abilities.
  def self.included controller_class
    controller_class.extend self::ClassMethods
    
    controller_class.module_eval do
    #  before_filter :acolyte_controls
      cattr_accessor :log_record_accessor
      attr_accessor :log_comment
    end
  end
  
  module ClassMethods
    # Defines a record accessor variable (give a symbol like :@party). +options+ can be
    # empty or a value for :only or :except, because it's an after_filter.
    def log record_accessor, options={}
      unless record_accessor.is_a?(Symbol) && record_accessor.to_s[0,1] == '@'
        raise ArgumentError, 'Instance variable symbol expected as first parameter'
      end
      self.log_record_accessor = record_accessor
      append_after_filter :log, options
    end
  end
  
protected
  
  # Logs the current action if flash[:success] is set. Saved are:
  # - the current time
  # - the id of the current user
  # - the id of the active expo
  # - the names of the current controller and action
  # - the name and id of the current record
  # - an optional log_comment
  def log options = {}
    if flash[:success]
      log_entry = LogEntry.new(
        :user_id    => (current_user.id if current_user),
        :expo_id    => (active_expo.id  if active_expo ),
        :controller => controller_name,
        :action     => action_name,
        :comment    => log_comment
      )
      if record = (options.delete(:record) || log_record)
        log_entry.record_id   = record.id
        log_entry.record_name = record.name
        log_entry.success     = !record.new_record? && (record.frozen? || record.valid?)
      else
        log_entry.success     = true
      end
      
      for key, value in options
        log_entry[key] = value
      end
      
      if log_entry.success?
        log_entry.save!
        flash[:debug] = flash.now[:debug] = log_entry.inspect if RAILS_ENV == 'development'
      end
    end
  end
  
  # Returns the record that gets logged (cached).
  def log_record
    @log_record ||= get_log_record
  end
  
  # Returns the value of the log instane record variable (eg. @party).
  def get_log_record
    instance_variable_get log_record_accessor if log_record_accessor
  end
  
end