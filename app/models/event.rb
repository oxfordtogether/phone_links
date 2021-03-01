class Event < ApplicationRecord
  include OclTools::Concerns::ExclusiveArc

  belongs_to :person
  belongs_to :relacement_event, optional: true, class_name: "Event"
  belongs_to :created_by, optional: true, class_name: "Person"

  belongs_to :match, optional: true
  belongs_to :report, optional: true
  belongs_to :note, optional: true

  has_exclusive :owning_object, from: %i[
    match report note
  ]

  scope :active, -> { where(replacement_event_id: nil) }
  scope :most_recent_first, -> { order(occurred_at: :desc) }

  encrypts :sensitive_data, type: :json, key: :kms_key

  def note_created?
    false
  end

  def report_created?
    false
  end

  def match_created?
    false
  end

  def match_ended?
    false
  end

  def flag_changed?
    false
  end

  def report_submitted?
    false
  end

  def active?
    !replacement_event_id
  end

  def self.non_sensitive_data_attr(name, type: nil)
    name_str = name.to_s
    supported_types = %i[symbol integer]
    raise "Unsupported type: #{type}" if type && !supported_types.include?(type)

    define_method(name) do
      val = non_sensitive_data[name_str]
      case type
      when :symbol
        val.to_sym
      when :integer
        val.to_i
      else
        val
      end
    end

    define_method("#{name}=") do |value|
      non_sensitive_data[name_str] = value
    end
  end

  def self.sensitive_data_attr(name, type: nil)
    name_str = name.to_s
    supported_types = %i[symbol integer]
    raise "Unsupported type: #{type}" if type && !supported_types.include?(type)

    define_method(name) do
      val = sensitive_data && sensitive_data[name_str]
      case type
      when :symbol
        val.to_sym
      when :integer
        val.to_i
      else
        val
      end
    end

    define_method("#{name}=") do |value|
      if sensitive_data
        sensitive_data[name_str] = value
      else
        self.sensitive_data = { name_str => value }
      end
    end
  end
end
