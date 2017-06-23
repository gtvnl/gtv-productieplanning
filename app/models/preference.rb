class Preference
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :setting, required: true, unique: true
  field :value, required: true
end
