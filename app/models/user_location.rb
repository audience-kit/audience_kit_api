class UserLocation < ApplicationRecord
  belongs_to :user
  belongs_to :locale
  belongs_to :venue

  scope :recent, -> { where('created_at > ?', 2.hours.ago) }

  after_create { self.notify }

  def notify
    config_file = Rails.root.join('config/kafka.yml')
    kafka_config = YAML.load_file(config_file)[Rails.env].symbolize_keys

    puts kafka_config

    kafka = Kafka.new **kafka_config

    producer = kafka.producer

    producer.produce(self.to_json, topic: 'user_locations', partition_key: self.user.id.to_s)

    producer.deliver_messages
  end
end
