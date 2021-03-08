# For providing the kms key to the models to decrypt their data

class KeyProvider
  def self.kms_key
    @@kms_key ||= new.kms_key
  end

  def kms_key
    KmsEncrypted::Database.new(self, :kms_key).decrypt(ENV["ENCRYPTED_KMS_KEY"])
  end

  def encrypt(key)
    KmsEncrypted::Database.new(self, :kms_key).encrypt(key)
  end

  def kms_encryption_context
    {
      name: "oxford_hub_phone_links",
      environment: ENV["KEY_PROVIDER_ENVIRONMENT"] || "development",
    }
  end

  def self.kms_keys
    {
      kms_key: {
        key_id: ENV["KMS_KEY_ID"],
        version: 1,
        previous_versions: nil,
        upgrade_context: false,
      },
    }
  end
end
