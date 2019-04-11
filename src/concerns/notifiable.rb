# Manages notifications for Models
#
# Usage:
#
# class Model
#   include Notifiable
#
#   notifies :created, :updated, notifier: ModelNotifier
#
#   def after_create
#     notify :created
#     notify :created, optioinal args can also be used
#     # `notify_created` can also be used
#     # `notify_created(optional_args)` can also be used
#   end
# end
#
# Notifier should have methods for the event names
#
# module ModelNotifier
#   extend self
#
#   def created(object)
#     puts "The model was created"
#   end
# end

require 'active_support/concern'

module Notifiable
  extend ActiveSupport::Concern

  module ClassMethods
    def notifies(*args)
      _args = args.clone # Avoid mutating input
      options = _args.last.is_a?(Hash) ? _args.pop : {}
      events = _args

      raise ArgumentError, ":notifier should be specified" if options[:notifier].nil?
      raise ArgumentError, "Please specify events to notify" if events.empty?

      notifier_class = options[:notifier]
      notifiable_events = events.map(&:to_sym)

      define_method :notifier do
        @notifier ||= notifier_class.new(self)
      end

      define_method :notify do |event, *args|
        if notifiable_events.include? event.to_sym
          notifier.send(event, *args)
        end
      end

      notifiable_events.each do |event|
        define_method "notify_#{event}" do |*args|
          self.notify event, *args
        end
      end
    end
  end
end
